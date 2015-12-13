



class NSNode

  include Lotus::Entity
      attributes :id, :owner_id, :identifier,  :name, :type, :meta, :docs, :children, :tags

  # include Noteshare
  require 'json'


  def self.lookup_by_name(node_name)
    NSNodeRepository.where(name: node_name).first
  end

  def self.create(name, owner_id, type, tags)
    NSNodeRepository.create(NSNode.new(name: name, owner_id: owner_id,
                                       type: type, tags: tags, identifier: Noteshare::Identifier.new().string))
  end

  def self.create_for_user(user)
     node =  NSNodeRepository.create(NSNode.new(owner_id: user.id, owner_identifier: user.identifier, name: user.screen_name, docs: "[]"))
     user.set_node(node.id)
     node
  end

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


  # update_docs_for_owner docs: replace current list with list of ids
  # and title root documents belonging to the owner of the node
  def update_docs_for_owner
    dd = DocumentRepository.root_documents_for_user(self.owner_id)
    hash_array = dd.map{ |doc| {id: doc.id, title: doc.title } }
    object_item_list = ObjectItemList.new(hash_array)
    self.docs  = object_item_list.encode
    NSNodeRepository.update self
  end

  def append_doc(id, title)
    oi = ObjectItem.new(id, title)
    oil = ObjectItemList.decode self.docs
    oil.append(oi)
    self.docs = oil.encode
    NSNodeRepository.update self
  end

  # Return an HTML list of links to documents
  def documents_as_list
    return '' if documents == nil or documents == []
    list = documents.table
    output = "<ul>\n"
    list.each do |item|
      output << "<li> <a href='/compiled/#{item.id}'>#{item.title}</a></li>\n"
    end
    output << "</ul>\n"
    output
  end


  def self.from_http(request)
    prefix = request.host.split('.')[0]
    if prefix
      NSNodeRepository.find_one_by_name(prefix)
    end
  end


  ##########  Manage the doc list ############

  # Retrieve the document list: unpack
  def documents
    if docs
      ObjectItemList.decode(self.docs)
    else
      []
    end
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

end
