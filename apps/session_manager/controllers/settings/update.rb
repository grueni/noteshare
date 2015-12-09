module SessionManager::Controllers::Settings
  class Update
    include SessionManager::Action

    expose :active_item

    def call(params)
      @active_item = ''
      user = current_user(session)
      data = params['user_settings']['settings_as_text']
      hash = data.hash_value(key_value_separator: '=', item_separator: "\n")
      user.dict_update_from_hash(hash)
      user.dict_display

      # self.body = 'OK'
      redirect_to "/node/user/#{current_user(session).id}"
    end
  end
end
