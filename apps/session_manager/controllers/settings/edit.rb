module SessionManager::Controllers::Settings
  class Edit
    include SessionManager::Action

    expose :unpacked_user_settings, :active_item

    def call(params)
      @active_item = ''
      keys = current_user(session).editable_keys

      @unpacked_user_settings = current_user(session).dict_to_s(keys)

    end


  end
end
