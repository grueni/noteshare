 module Web::Controllers::Documents
  class Index
    include Web::Action

    expose :documents, :nodes
    expose :active_item

    def yono(arg) false end


    def call(params)
      @documents = DocumentRepository.basic_search(nil, '', 'document', 'all').select{ |item| (item.acl_get(:world) =~ /r/) }.sort_by { |item| item.title }
      # @documents = (DocumentRepository.root_documents.all.select &can_read(current_user2)).sort_by { |item| item.title }
      @active_item = 'documents'
      @nodes = NSNodeRepository.public.sort_by { |item| item.name }
    end

  end

end
