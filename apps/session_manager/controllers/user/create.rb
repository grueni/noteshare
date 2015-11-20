require 'bcrypt'

module SessionManager::Controllers::User

  class Create
    include SessionManager::Action

    def call(params)

      new_user = User.create(params[:user])
      password = params[:user]['password']

      if new_user
        NSNode.create_for_user(new_user)
        new_user.login(password, session)
      end

      if new_user
        redirect_to  "/node/user/#{new_user.id}"
      else
        redirect_to '/'
      end

    end

  end
end

