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

      if cu
        search_scope = cu.dict2['search_scope'] || 'all'
        search_mode = cu.dict2['search_mode'] || 'document'
      else
        search_scope = 'all'
        search_mode = 'document'
      end

      puts "search_mode = #{search_mode}, search_scope = #{search_scope}".green

      case search_scope
        when 'global'
          @documents = DocumentRepository.basic_search(nil, search_key, 'document', 'all')
          @documents = @documents.select{ |item| item.acl_get(:world) =~ /r/ } || [] 
        when 'local'
          @documents = DocumentRepository.basic_search(cu, search_key, search_mode, 'personal') || []
        else
          @documents = []
      end

      @nodes = NSNodeRepository.search(search_key).sort_by { |item| item.name }
    end

  end
end

# search_local(user, key, limit: 20)