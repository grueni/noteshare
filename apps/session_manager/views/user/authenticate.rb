module SessionManager::Views::User
  class Authenticate
    include SessionManager::View

     def screen_name
       user = UserRepository.find session[:user_id]
       user.screen_name
     end

  end
end
