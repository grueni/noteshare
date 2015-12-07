module SessionManager::Controllers::Settings
  class Update
    include SessionManager::Action

    def call(params)

      user = current_user(session)
      data = params['user_settings']['settings_as_text']
      hash = data.hash_value(key_value_separator: '=', item_separator: "\n")
      puts hash.to_s.cyan
      user.dict_update_from_hash(hash)
      puts '----------------------------'
      user.dict_display
      puts '----------------------------'

      # self.body = 'OK'
      redirect_to "/node/user/#{current_user(session).id}"
    end
  end
end
