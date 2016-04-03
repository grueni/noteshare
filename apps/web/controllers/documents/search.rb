require_relative '../../../../lib/noteshare/interactors/web/searcher'

module Web::Controllers::Documents
  class Search
    include Web::Action

    expose :documents, :nodes
    expose :active_item

    def call(params)
      @active_item = 'reader'
      result = Searcher.new(params, current_user2).call
      @documents = result.documents
      @nodes = result.nodes
    end

  end
end

# search_local(user, key, limit: 20)