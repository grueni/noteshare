module Web::Controllers::Documents
  class Search
    include Web::Action
'
'
    expose :documents
    expose :active_item

    def call(params)
      @active_item = ''
      search_key = params['search']['search']
      puts "SEARCH KEY = #{search_key}"
      @documents = DocumentRepository.root_document_by_title(search_key)
      puts "N = #{@documents.count} documents"

      # redirect_to '/documents'
    end

  end
end
