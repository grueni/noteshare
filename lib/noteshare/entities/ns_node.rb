



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
    domain = ENV['DOMAIN'] || '.localhost'
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
    docs_string = ''
    dd.each do |doc|
      docs_string << "#{doc.title}, #{doc.id}; "
    end
    dict['docs'] = docs_string
    NSNodeRepository.update self
  end

  def update_docs_for_from_pair_list(pair_list)
    hash_array = []
    pair_list.each do |pair|
      hash = {}
      hash[:title] = pair[0]
      hash[:id] = pair[1]
      hash_array << hash
    end
    object_item_list = ObjectItemList.new(hash_array)
    self.docs  = object_item_list.encode
    NSNodeRepository.update self
  end

  def append_doc(id, title)
    dict['docs'] << "#{title}, #{id};"
    NSNodeRepository.update self
  end

  def delete_all_docs
    dict['docs'] = ''
    NSNodeRepository.update self
  end

  def titlepage_list(hash)
    output = "<ul>\n"
    hash.each do |title, id|
      output << "<li> <a href='/titlepage/#{id}'>#{title}</a></li>\n"
    end
    output << "</ul>\n"
    output
  end

  def sidebar_list(hash)
    hash = "<ul>\n"
    hash.each do |title, id|
      output << "<li> <a href='/aside/#{id}'>#{title}</a></li>\n"
    end
    output << "</ul>\n"
    output
  end

  # Return an HTML list of links to documents
  def documents_as_list(option=:titlepage)
    hash = documents_as_hash # as array of pairs [title, id]
    return '' if hash == {}
    case option
      when :titlepage
        titlepage_list(hash)
      when :sidebar
        sidebar_list(hash)
      else
        titlepage_list(hash)
    end
  end

  # Retrieve the document list: unpack

  def documents_as_hash
    documents_string =  dict['docs'] || ''
    documents_string.hash_value(",;")
  end

  def documents
    documents_string =  dict['docs'] || ''
    documents_string.to_pair_list
  end

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
  def add_document_by_id(id)
    doc = DocumentRepository.find id
    if doc
      append_doc(id, doc.title)
    end

  end




  #### DICT ####

  def blurb
    dict['blurb'] || '--'
  end

end
