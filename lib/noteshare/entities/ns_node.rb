class NSNode
  include Lotus::Entity
  attributes :id, :owner_id, :name, :type, :meta, :docs, :children

  require 'json'


  # update_docs_for_owner docs: replace current list with list of ids of
  # root documents belonging to the owner of the node
  def update_docs_for_owner
    dd = DocumentRepository.root_documents_for_user self.owner_id
    doc_data = dd.map{ |doc| [doc.id, doc.title]}
    self.docs  = JSON.generate doc_data
    NSNodeRepository.update self
  end

  def documents
    JSON.parse self.docs
  end

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
