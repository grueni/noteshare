module Admin::Controllers::Users
  class Delete
    include Admin::Action

    def call(params)
      redirect_if_not_admin('Attempt to delete user (admin, users, delete)')
      id = params['id']
      puts "Admin, Delete, id = #{id}".red
      User.delete_with_dependents(id)
      redirect_to '/admin/users'
    end

  end
end
