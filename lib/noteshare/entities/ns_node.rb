



class NSNode

  include Lotus::Entity
      attributes :id, :owner_id, :identifier,  :name, :type,
                 :meta, :docs, :children, :tags, :xattributes, :dict

  include Asciidoctor

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
    puts "request.host: #{request.host}".red
    puts "request.referer: #{request.referer}".red
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
      p = Publications.add_record(self.id, doc.id, 'author')
      puts "P: #{p.id}".cyan
    end
  end

  # Add document to the given node
  # The allowable types are 'author', 'principal', and 'standard'
  def append_doc(document_id, type)
    Publications.add_record(self.id, document_id, type)
  end

  def remove_doc(document_id)
    Publications.remove(self.id, document_id)
  end

  def delete_all_docs
  end

  def html_list(docs, view_mode)
    output = "<ul>\n"
    docs.each do |doc|
      output << "<li> <a href='/#{view_mode}/#{doc.id}'>#{doc.title}</a></li>\n"
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
        html_list(docs, 'titlepage')
      when :sidebar
        html_list(docs, 'aside')
      when :view_source
        html_list(docs, 'view_source')
      when :compiled
        html_list(docs, 'compiled')
      else
        html_list(docs, 'document')
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
      Publications.add_record(self.id, doc_id, 'author')
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
    # value of type: 'author', 'principal', 'ordinary'
    type = hash[:type] || 'ordinary'
    puts "Adding document #{document_id} to node #{self.id} with type #{type}".red
    doc = DocumentRepository.find document_id
    if doc
      Publications.add_record(self.id, document_id, type)
    end
  end




  #### DICT ####

  def blurb
    dict['blurb'] || '--'
  end

  def update_sidebar_text
    meta['rendered_sidebar_text'] = Asciidoctor.convert meta['sidebar_text']
    NSNodeRepository.update self
  end

end
