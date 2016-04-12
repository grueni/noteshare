require_relative '../../../../lib/noteshare/interactors/web/searcher'
require 'pry'

module Web::Controllers::Documents
  class Search
    include Web::Action
    include Noteshare::Interactor::Search

    expose :documents, :nodes
    expose :active_item

    def do_command(search_key)
      if search_key and search_key[0] == '!'
        command = search_key[1..-1]
        puts "in do_command, search_key = #{search_key}".cyan
        redirect_to "/admin/process_command?#{command}::#{ENV['COMMAND_SECRET_TOKEN']}"
      end
    end

    def call(params)
      # binding.pry
      @active_item = 'reader'
      search_key = params['search']['search']

      puts "search_key = #{search_key}".red
      do_command(search_key)

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