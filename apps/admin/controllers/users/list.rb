module Admin::Controllers::Users
  class List
    include Admin::Action

    expose :users, :active_item

    def call(params)
      @active_item = 'admin'
      @users = UserRepository.all
    end

  end
end
