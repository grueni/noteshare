



class NSNode

  include Lotus::Entity
      attributes :id, :owner_id, :identifier,  :name, :type, :meta, :docs, :children

  include Noteshare
  require 'json'


  def self.create_for_user(user)
     node =  NSNodeRepository.create(NSNode.new(owner_id: user.id, owner_identifier: user.identifier, name: user.screen_name))
     user.set_node(node.id)
  end

  def owner_name
    return if owner_id == nil
    owner = UserRepository.find(owner_id)
    return if owner == nil
    owner.full_name if owner
  end


  # update_docs_for_owner docs: replace current list with list of ids
  # and title root documents belonging to the owner of the node
  def update_docs_for_owner
    dd = DocumentRepository.root_documents_for_user self.owner_id
    puts "docs: #{dd.count}"
    hash_array = dd.map{ |doc| {id: doc.id, title: doc.title } }
    puts hash_array.to_s
    object_item_list = ObjectItemList.new(hash_array)
    puts object_item_list.display
    self.docs  = object_item_list.encode
    NSNodeRepository.update self
  end

  # Retrieve the document list: unpack
  def documents
    if docs
      ObjectItemList.decode(self.docs)
    else
      []
      end
  end

  # Return an HTML list of links to documents
  def documents_as_list
    list = documents.table
    output = "<ul>\n"
    list.each do |item|
      output << "<li> <a href='/document/#{item.id}'>#{item.title}</a></li>\n"
    end
    output << "</ul>\n"
    output
  end

end
