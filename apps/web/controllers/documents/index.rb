 module Web::Controllers::Documents
  class Index
    include Web::Action

    expose :documents, :nodes
    expose :active_item

    def yono(arg) false end


    def call(params)
      user = current_user(session)
      @documents = (DocumentRepository.root_documents.all.select &can_read(user)).sort_by { |item| item.title }
      @active_item = 'documents'
      @nodes = NSNodeRepository.all.sort_by { |item| item.name }
    end

  end

end
