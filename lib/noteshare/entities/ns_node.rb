class NSNode
  include Lotus::Entity
      attributes :id, :owner_id, :identifier,  :name, :type, :meta, :docs, :children

  require 'json'


  def self.create_for_user(user)
      NSNodeRepository.create(NSNode.new(owner_id: user.id, owner_identifier: user.identifier, name: user.screen_name))
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
    doc_data = dd.map{ |doc| [doc.id, doc.title]}
    self.docs  = JSON.generate doc_data
    NSNodeRepository.update self
  end

  # Retrieve the document list: unpack
  def documents
    if docs
      JSON.parse docs
    else
      []
      end
  end

  # Return an HTML list of links to documents
  def documents_as_list
    list = documents
    output = "<ul>\n"
    list.each do |id, title|
      output << "<li> <a href='/document/#{id}'>#{title}</a></li>\n"
    end
    output << "</ul>\n"
    output
  end

end
