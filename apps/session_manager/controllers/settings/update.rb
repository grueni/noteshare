module SessionManager::Controllers::Settings
  class Update
    include SessionManager::Action

    expose :active_item

    def call(params)
      puts "User settings".red
      redirect_if_not_signed_in('session_manager, Settings,  Update')
      @active_item = ''
      user = current_user(session)
      data = params['user_settings']['settings_as_text']
      puts "data:\n#{data}\n-----\n".cyan
      hash = data.hash_value(":;")
      puts "hash:\n#{hash}\n-----\n".cyan
      user.dict2 = hash
      puts user.dict2.to_s.red
      UserRepository.update user

      # self.body = 'OK'
      redirect_to "/node/user/#{current_user(session).id}"
    end
  end
end
