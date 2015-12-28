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
      puts "SEARCH KEY = #{search_key}"
      @documents = DocumentRepository.search(search_key).sort_by { |item| item.title }
      @nodes = NSNodeRepository.search(search_key).sort_by { |item| item.name }

      puts "N = #{@documents.count} documents"

      # redirect_to '/documents'
    end

  end
end
