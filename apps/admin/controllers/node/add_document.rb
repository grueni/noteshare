 module Admin::Controllers::Node
  class AddDocument
    include Admin::Action

    expose :active_item
    def get_doc_id_from_title(id)
      documents = DocumentRepository.find_by_title(id)
      redirect_to "/error/4?Could not find any matching documents" if documents == nil
      redirect_to "/error/4?document matches: not UNIQUE" if documents.count != 1
      document = documents[0]
      document.id
    end

    def call(params)
      redirect_if_not_admin('Attempt to add document to node (admin, node, show add document)')
      @active_item = 'admin'
      node_id = params['admin']['node_id']
      doc_id = params['admin']['document_id']

      doc_id = get_doc_id_from_title(doc_id) if (doc_id =~ /^\d*\d$/) != 0

      node = NSNodeRepository.find node_id
      doc = DocumentRepository.find doc_id
      node.publish_document(id: doc_id, type: 'publisher')
      NSNodeRepository.update node
      redirect_to "/node/#{node_id}"
    end

  end
end
