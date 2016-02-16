module Web::Controllers::Documents
  class SetSearchType
    include Web::Action

    def call(params)
      data = request.env['rack.request.form_vars']
      search_type = data.match(/search_type=(.*?)&/)[1]
      cu = current_user(session)
      if cu
        cu.dict2['search_type'] = search_type
        UserRepository.update cu
      end
      # self.body = 'set search type -- OK'
    end

  end
end
