module Web::Controllers::Documents
  class SetSearchType
    include Web::Action

    def call(params)

      data = request.env['rack.request.form_vars']

      search_scope_matcher = data.match(/search_scope=(.*?)&/)
      search_scope =  search_scope_matcher[1] if  search_scope_matcher
      puts "SST: search_scope = #{search_scope}".red

      search_mode_matcher = data.match(/search_mode=(.*?)&/)
      search_mode = search_mode_matcher[1] if search_mode_matcher
      puts "SST: search_mode = #{search_mode}".red

      puts "I AM SETTING THE SEARCH MODE TO #{search_mode}".magenta

      if current_user2
        current_user2.dict2['search_scope'] = search_scope || 'local'
        current_user2.dict2['search_mode'] = search_mode || 'document'
        UserRepository.update current_user2
      end

      self.body = 'set search type -- OK'
    end

  end
end
