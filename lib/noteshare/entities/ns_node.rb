



class NSNode

  include Lotus::Entity
      attributes :id, :owner_id, :identifier,  :name, :type,
                 :meta, :docs, :children, :tags, :xattributes, :dict

  # include Noteshare
  require 'json'

  def initialize(hash)

    hash.each { |name, value| instance_variable_set("@#{name}", value) }

    @xattributes ||= []
    @dict ||= {}

    # @toc_dirty ||= true

  end





  #### FINDERS ####

  def self.lookup_by_name(node_name)
    NSNodeRepository.where(name: node_name).first
  end





  #### CREATORS ####

  def self.create(name, owner_id, type, tags)
    NSNodeRepository.create(NSNode.new(name: name, owner_id: owner_id,
                                       type: type, tags: tags, identifier: Noteshare::Identifier.new().string))
  end

  def self.create_for_user(user)
     node =  NSNodeRepository.create(NSNode.new(owner_id: user.id, owner_identifier: user.identifier, name: user.screen_name, type: 'personal', docs: "[]"))
     user.set_node(node.id)
     node
  end




  #### USER ####

  def owner_name
    return if owner_id == nil
    owner = UserRepository.find(owner_id)
    return if owner == nil
    owner.full_name if owner
  end

  def url
    domain = ENV['DOMAIN']
    puts "domain: #[domain}"
    "#{self.name}#{domain}"
  end


  #### ???? ####

  def self.from_http(request)
    prefix = request.host.split('.')[0]
    if prefix
      NSNodeRepository.find_one_by_name(prefix)
    end
  end





  #### DOCS ####

  # A node maintains a list of 'published' documents as the value of
  # node.dict['docs'].  That value is a string of the form
  #
  #    doc_title_1, doc_id_1; doc_title_2, doc_id_2; ...
  #
  # It can be transformed into an array of pairs by saying
  #
  #    node.dict['docs'].to_pair_list
  #
  #    => [[doc_title_1, doc_id_1], [doc_title_2, doc_id_2], ...]
  #
  # and it can be transformed into a hash by
  #
  #    node.dict['docs'].hash_value(key_value_separator: ',', item_separator: ';')
  #
  #    => { 'doc_title_1': doc_id_1, 'doc_title_2': doc_id_2, ...]
  #


  # update_docs_for_owner docs: replace current list with list of ids
  # and title root documents belonging to the owner of the node
  def update_docs_for_owner
    return if type != 'personal'
    dd = DocumentRepository.root_documents_for_user(self.owner_id)
    dd.each do |doc|
      p = Publications.add_record(self.id, doc.id)
      puts "P: #{p.id}".cyan
    end
  end

  def append_doc(document_id)
    Publications.add_record(self.id, document_id)
  end

  def remove_doc(document_id)
    Publications.remove(self.id, document_id)
  end

  def delete_all_docs
  end

  def titlepage_list(docs)
    output = "<ul>\n"
    docs.each do |doc|
      output << "<li> <a href='/titlepage/#{doc.id}'>#{doc.title}</a></li>\n"
    end
    output << "</ul>\n"
    output
  end

  def sidebar_list(docs)
    output = "<ul>\n"
    docs.each do |doc|
      output << "<li> <a href='/aside/#{doc.id}'>#{doc.title}</a></li>\n"
    end
    output << "</ul>\n"
    output
  end

  # Return an HTML list of links to documents
  def documents_as_list(user, option)
    user ? docs = self.documents_readable_by(user) : docs = self.public_documents
    return '' if docs == []
    case option
      when :titlepage
        titlepage_list(docs)
      when :sidebar
        sidebar_list(docs)
      else
        titlepage_list(docs)
    end
  end

  #################################################

  def publication_records
    PublicationsRepository.records_for_node(self.id)
  end

  def publication_records_as_string
    output = 'docs: '
    publication_records.all.each do |record|
       output << "#{record.document_title}, #{record.document_id}; "
    end
    output
  end

  def update_publication_records_from_string(str)
    self.publication_records.all.each do |record|
      PublicationsRepository.delete record
    end
    hash = str.hash_value(',;')
    hash.each do |doc_title, doc_id|
      puts "#{doc_title}: #{doc_id}".cyan
      Publications.add_record(self.id, doc_id)
    end
  end

  def documents
    Publications.documents_for_node(self.id)
  end

  def public_documents
    Publications.documents_for_node(self.id)
  end

  def documents_readable_by(user)
    Publications.documents_for_node(self.id).select(&can_read(user)).sort_by { |item| item.title }
  end

  #################################################

  def documents_as_hash
    documents_string =  dict['docs'] || ''
    documents_string.hash_value(',;')
  end

  def documents_as_string
    dict['docs'] || ''
  end

  def document_count
    documents.count
  end

  # Add a document
  def publish_document(hash)
    document_id = hash[:id]
    type = hash[:type]
    puts "Adding document #{document_id} to node #{self.id} with type #{type}".red
    doc = DocumentRepository.find document_id
    if doc
      Publications.add_record(self.id, document_id)
    end
  end




  #### DICT ####

  def blurb
    dict['blurb'] || '--'
  end

end
