 module Web::Controllers::Documents
  class Index
    include Web::Action

    expose :documents, :nodes
    expose :active_item

    def yono(arg) false end


    def call(params)

      # @documents = DocumentRepository.root_documents.sort_by { |item| item.title }
      user = current_user(session)
      # @documents = DocumentRepository.root_documents.all.select{ |doc| Permission.new(user, :read, doc).grant }.sort_by { |item| item.title }
      @documents = DocumentRepository.root_documents.all.select &can_read(user)
      @active_item = 'documents'

      @nodes = NSNodeRepository.all
    end

  end

end
