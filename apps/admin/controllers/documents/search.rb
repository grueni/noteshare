require_relative '../../../../lib/noteshare/interactors/advanced_searcher'


module Admin::Controllers::Documents
  class Search
    include Admin::Action


    expose :documents, :document_count, :active_item

    def call(params)
      puts "HERE I AM BOSS!".green
      @active_item = 'admin'
      payload = params['search'] || {}
      search_key = payload['search'] || ''
      result = AdvancedSearcher.new(search_key, current_user2).call
      @documents = result.documents
      number_of_docs = @documents.count

      if number_of_docs == 1
        @document_count = "1 document"
      else
        @document_count = "#{number_of_docs} documents"
      end

    end

  end
end
