module Node::Controllers::Admin
  class List
    include Node::Action

    expose :nodes, :active_item, :documents

    def call(paramm)
      @active_item = 'admin'
      puts "call: controller Node, Admin, List".red
      @nodes = NSNodeRepository.public
      @documents = DocumentRepository.root_documents.sort_by{|document| document.title}
      puts "exit controller node, admin, list".red
    end

  end
end
