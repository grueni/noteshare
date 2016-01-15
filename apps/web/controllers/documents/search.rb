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
      cu = current_user(session)
      if cu == nil
        puts 'DOING SEARCH FOR ALL'.red
        @documents = DocumentRepository.search(search_key).sort_by { |item| item.title }
      else
        if cu.dict2['search_type'] == 'local'
          puts 'DOING LOCAL SEARCH'.red
          @documents = DocumentRepository.search_local(cu, search_key).sort_by { |item| item.title }
        elsif cu.dict2['search_type'] == 'global'
          puts 'DOING GLOBAL SEARCH'.red
          @documents = DocumentRepository.search_global(cu, search_key).sort_by { |item| item.title }
        else
          puts 'DOING SEARCH FOR ALL'.red
          @documents = DocumentRepository.search(search_key).sort_by { |item| item.title }
        end
      end
      @nodes = NSNodeRepository.search(search_key).sort_by { |item| item.name }
    end

  end
end

# search_local(user, key, limit: 20)