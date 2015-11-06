require 'bcrypt'

module SessionManager::Controllers::User

  class Create
    include SessionManager::Action

    def call(params)
      puts "controller SessionManager, create new user".magenta
      # data = params[:user]
      new_user = User.new(params[:user])
      if new_user.password == new_user.password_confirmation
        new_user.password = BCrypt::Password.create(new_user.password)
        new_user.password_confirmation = ''
        UserRepository.create new_user
      end


      redirect_to '/admin/users'
    end

  end
end
