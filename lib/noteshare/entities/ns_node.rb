class NSNode
  include Lotus::Entity
  attributes :id, :owner_id, :name, :type, :meta, :docs, :children


  # update_docs_for_owner docs: replace current list with list of ids of
  # root documents belonging to the owner of the node
  def update_docs_for_owner
    dd = DocumentRepository.root_documents_for_user self.owner_id
    doc_ids = dd.map{ |doc| doc.id}
    self.docs  = doc_ids
    NSNodeRepository.update self
  end

  def documents
    _docs = self.docs.map{ |id| DocumentRepository.find id }
  end

end
