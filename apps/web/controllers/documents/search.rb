module Web::Controllers::Documents
  class Search
    include Web::Action
'
'
    expose :documents

    def call(params)
      search_key = params['search']['search']
      puts "SEARCH KEY = #{search_key}"
      @documents = DocumentRepository.by_title(search_key)
      puts "N = #{@documents.count} documents"

      redirect_to '/documents'
    end

  end
end
