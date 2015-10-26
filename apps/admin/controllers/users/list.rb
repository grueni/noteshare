module Admin::Controllers::Users
  class List
    include Admin::Action

    expose :users

    def call(params)
      @users = UsersRepository.all
    end
  end
end
