require 'lotus/interactor'

module Noteshare
  module Interactor
    module Search
      class AdvancedSearcher

        include Lotus::Interactor
        expose :documents

        def initialize(search_key=nil, user=nil)
          @search_key = search_key
          @user = user
        end

        def commands
          %w(ti ta au)
        end

        def configure
          parts = @search_key.split(' ')
          if parts.count > 1 and commands.include? parts[0]
            @command = parts[0]
            @search_key = @search_key.sub(@command, '').strip
          end
        end

        def advanced_search
          puts "advanced search on command #{@command} with key #{@search_key}".red
          case @command
            when 'ti'
              # @documents = DocumentRepository.search_with_title(@search_key, root_documents_only: 'yes')
              @documents = DocumentRepository.search_with_title(@search_key)
            when 'ta'
              @documents = DocumentRepository.search_with_tags(@search_key)
            when 'au'
              user = UserRepository.find_one_by_screen_name @search_key
              if user
                # @documents = DocumentRepository.find_by_author_id(user.id)
                @documents = DocumentRepository.find_by_author_id(user.id, root_documents_only: 'yes')
              else
                @documents = []
              end
            else
              @documents = DocumentRepository.search_with_title(@search_key)
          end
        end

        def search_documents
          if @command == nil
            @documents = DocumentRepository.search_with_title(@search_key)
          else
            advanced_search
          end
        end


        def call
          configure
          search_documents
        end

      end

    end
  end
end


