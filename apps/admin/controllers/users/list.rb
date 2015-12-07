module Admin::Controllers::Users
  class List
    include Admin::Action

    expose :users, :active_item

    def call(params)
      @active_item = 'editor'
      puts "admin controller users"
      @users = UserRepository.all
    end

  end
end
