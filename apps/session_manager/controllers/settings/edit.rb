module SessionManager::Controllers::Settings
  class Edit
    include SessionManager::Action

    expose :unpacked_user_settings, :active_item

    def call(params)
      @active_item = ''
      redirect_if_not_signed_in('session_manager, Settings,  Edit')
      keys = %w(render_with) # editable_keys

      @unpacked_user_settings = current_user(session).dict2.string_val(:vertical_strict)

    end


  end
end
