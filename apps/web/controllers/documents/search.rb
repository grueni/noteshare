require_relative '../../../../lib/noteshare/interactors/web/searcher'

module Web::Controllers::Documents
  class Search
    include Web::Action

    expose :documents, :nodes
    expose :active_item

    def call(params)
      @active_item = 'reader'
      search_key = params['search']['search']
      search_key_parts = search_key.split(' ')
      command = search_key_parts[0]
      commands = AdvancedSearcher.new().commands
      puts "commands = #{commands}".red
      puts "command = #{command}".red
      puts "search key = #{search_key}".red
      puts "search_key_parts = #{search_key_parts}".cyan
      if command and commands.include? command
        result = AdvancedSearcher.new(search_key, current_user2).call
        @documents = result.documents
        @nodes = []
      else
        result = Searcher.new(params, current_user2).call
        @documents = result.documents
        @nodes = result.nodes
      end

    end

  end
end

# search_local(user, key, limit: 20)