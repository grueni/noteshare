module Admin::Controllers::Users
  class List
    include Admin::Action

    expose :users

    def call(params)
      puts "admin controller users"
      @users = UserRepository.all
    end

  end
end
