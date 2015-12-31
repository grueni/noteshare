module Web::Controllers::Documents
  class Search
    include Web::Action
'
'
    expose :documents, :nodes
    expose :active_item

    def call(params)
      @active_item = 'reader'
      search_key = params['search']['search']
      @documents = DocumentRepository.search(search_key).sort_by { |item| item.title }
      @nodes = NSNodeRepository.search(search_key).sort_by { |item| item.name }
    end

  end
end
