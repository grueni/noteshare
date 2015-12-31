require 'bcrypt'

module SessionManager::Controllers::User

  class Create
    include SessionManager::Action

    def call(params)

      puts "IN: SessionManager, User, Create".red

      new_user = User.create(params[:user])
      password = params[:user]['password']

      if new_user
        new_node = NSNode.create_for_user(new_user)
        new_user.dict2['node'] = new_node.id
        UserRepository.update new_user
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

