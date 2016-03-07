module Admin::Controllers::Users
  class List
    include Admin::Action

    expose :users, :active_item

    def call(params)
      redirect_if_not_admin('Attempt to list users (admin, users, list)')
      @active_item = 'admin'
      @users = UserRepository.all.sort_by{ |user| user.updated_at }.reverse
    end

  end
end
