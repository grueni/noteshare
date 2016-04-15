require_relative '../../../../lib/user_authentication'
include HR::Core::SessionTools

module SessionManager::Views::User
  class Authenticate
    include SessionManager::View

     def screen_name
       user = current_user(session)
       user.screen_name
     end

  end
end
