module SessionManager::Controllers::User
  class Create
    include SessionManager::Action

    def call(params)
      puts ">> Controller, create new user".magenta
      # data = params[:user]
      new_user = User.new(params[:user])
      UserRepository.create new_user
    end

  end
end
