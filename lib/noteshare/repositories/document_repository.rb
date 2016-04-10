require 'sequel'
require 'sequel/extensions/pg_array'
require 'sequel/extensions/pg_hstore'

# DocumentRepository.all.select{ |doc| doc.acl['world'] == 'r' }.count

# DocumentRespository provides services for
# persistence and search to NSDocument
class DocumentRepository
  include Lotus::Repository

  # Find all objects with a given title
  def self.find_by_title1(title)
    query do
      where(title: title)
    end
  end

  def self.find_by_author_id(author_id, hash={})
    if hash[:root_documents_only] == 'yes'
      query do
        where(author_id: author_id, root_document_id: 0)
      end
    else
      query do
        where(author_id: author_id)
      end
    end
  end

  def self.delete_all_documents_of_author(author_id)
    docs = self.find_by_author_id(author_id)
    docs.each do |doc|
      puts "deletings document #{doc.id}".red
      doc.delete
    end
  end

  def self.find_by_dict_entry(hash)
    query do
      where(Sequel.hstore_op(:dict).contains(hash))
    end
  end

  def self.find_by_doc_attribute(attr)
    query do
      where(Sequel.pg_array_op(:xattributes).contains([attr]))
    end
  end

  def self.find_by_doc_attribute2(attr)
    query do
      where(Sequel.pg_array_op(:xattributes).matches(attr))
    end
  end


  def self.find_by_title(key, limit: 8)
    array = fetch("SELECT id FROM documents WHERE title ILIKE '%#{key}%';")
    array = array.map{ |h| h[:id] }.uniq
    array.map{ |id| DocumentRepository.find id }.sort_by { |item| item.title }
  end

  # Return one ob4ect (or none0 whidh
  # have a given title
  # Fixme: this could be problmatic because
  # of the possibility of multiple objects with the same title
  def self.find_one_by_title(title)
    self.find_by_title(title).first
  end

  # Return all root documents
  def self.root_documents
    query do
      where(root_document_id: 0).select{ |item| item.title }
    end
  end

  def self.root_documents_for_user(author_id)
    query do
      where(root_document_id: 0, author_id: author_id)
    end
  end

  ############################


  def self.search_with_title(key, hash={})
    if hash[:root_documents_only] == 'yes'
      array = fetch("SELECT id FROM documents WHERE title ILIKE '%#{key}% AND root_document_id = 0'")
    else
      array = fetch("SELECT id FROM documents WHERE title ILIKE '%#{key}%'")
    end


    array = array.map{ |h| h[:id] }.uniq
    array.map{ |id| DocumentRepository.find id }.sort_by { |item| item.title }
  end

  def self.search_with_tags(key)
    array = fetch("SELECT id FROM documents WHERE tags ILIKE '%#{key}%'")
    array = array.map{ |h| h[:id] }.uniq
    array.map{ |id| DocumentRepository.find id }.sort_by { |item| item.title }
  end

  ###########################

  def self.basic_search(user, key, mode, scope, limit: 20)

    puts "Search where key = #{key} mode = #{mode}, scope = #{scope}".red

    case scope
      when 'personal'
        user ? scope_clause = "AND author_id = #{user.id}" : ''
      when 'other'
        user ? scope_clause = "AND author_id != #{user.id}"  : ''
      when  'all'
        scope_clause =  ""
      else
        scope_clause =  ""
    end

    case mode
      when 'document'
        mode_clause = "AND parent_id = 0"
      when 'section'
        mode_clause = ''
      when 'text'
        mode_clause = ''
      else
        mode_clause = ''
    end

    case mode
      when 'document'
        search_clause = "WHERE (title ILIKE '%#{key}%' OR tags ILIKE '%#{key}%')"
      when 'section'
        search_clause = "WHERE (title ILIKE '%#{key}%' OR tags ILIKE '%#{key}%')"
      when 'text'
        search_clause = "WHERE content ILIKE '%#{key}%'"
      else
        search_clause = "WHERE (title ILIKE '%#{key}%' OR tags ILIKE '%#{key}%')"
    end

    query = "SELECT id FROM documents #{search_clause} #{scope_clause} #{mode_clause} "
    puts "QUERY: #{query}".red
    array = fetch(query)
    array = array.map{ |h| h[:id] }.uniq
    puts "Found #{array.count} items".cyan
    array.map{ |id| DocumentRepository.find id }.select{ |item| item.title }.sort_by{ |item| item.title }
  end


  # List all descendants of a given document
  def self.descendants(doc_id)
    query do
      where(root_document_id: doc_id)
    end
  end

  # Destroy all descendants of a given
  # document and the document itself
  def self.destroy_tree(doc_id, switches = [:verbose ])
    descendants = self.descendants(doc_id)
    n = descendants.count
    descendants.each do |doc|
      puts "#{doc.id}: #{doc.title}" if switches.include? :verbose
      DocumentRepository.delete doc if switches.include? :kill
    end
    doc = DocumentRepository.find(doc_id) if switches.include? :verbose
    author_node = NSNodeRepository.for_owner_id doc.author_id
    DocumentRepository.delete(doc) if switches.include? :kill
    author_node.update_docs_for_owner if author_node
  end


end