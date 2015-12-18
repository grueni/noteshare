require 'sequel'
require 'sequel/extensions/pg_array'
require 'sequel/extensions/pg_hstore'



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

  def self.find_by_dict_entry(hash)
    query do
      where(Sequel.hstore_op(:dict).contains(hash))
    end
  end

  def self.find_by_doc_attribute(attr)
    query do
      where(Sequel.pg_array_op(:doc_attributes).contains([attr]))
    end
  end

  def self.find_by_doc_attribute2(attr)
    query do
      where(Sequel.pg_array_op(:doc_attributes).matches(attr))
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
      where(root_document_id: 0)
    end
  end

  def self.root_documents_for_user(author_id)
    query do
      where(root_document_id: 0, author_id: author_id)
    end
  end

  def self.root_document_by_title(key, limit: 8)
    array = fetch("SELECT id FROM documents WHERE parent_id = 0 AND title ILIKE '%#{key}%';")
    array = array.map{ |h| h[:id] }.uniq
    array.map{ |id| DocumentRepository.find id }.sort_by { |item| item.title }
  end


  # List all descendants of a given document
  def self.descendants(doc_id)
    query do
      where(root_document_id: doc_id)
    end
  end

  # Destroy all descendants of a given
  # document and the document itself
  def self.                                                                                                                                                 destroy_tree(doc_id, switches = [:verbose ])
    descendants = self.descendants(doc_id)
    n = descendants.count
    descendants.each do |doc|
      puts "#{doc.id}: #{doc.title}" if switches.include? :verbose
      DocumentRepository.delete doc if switches.include? :kill
    end
    doc = DocumentRepository.find(doc_id) if switches.include? :verbose
    author_node = NSNodeRepository.for_owner_id doc.author_id
    DocumentRepository.delete(doc) if switches.include? :kill
    author_node.update_docs_for_owner
  end

end