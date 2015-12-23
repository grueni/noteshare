module Admin::Controllers::Node
  class AddDocument
    include Admin::Action

    expose :active_item

    def call(params)
      @active_item = 'admin'
      node_id = params['admin']['node_id']
      doc_id = params['admin']['document_id']
      puts "doc_id: #{doc_id}".red
      node = NSNodeRepository.find node_id
      doc = DocumentRepository.find doc_id
      puts "Boss, I will add document #{doc.title} to node #{node.name}".red
      node.add_document_by_id(doc_id)
      NSNodeRepository.update node
      redirect_to "/node/#{node_id}"
    end

  end
end
