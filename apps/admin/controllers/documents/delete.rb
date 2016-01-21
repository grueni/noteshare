module Admin::Controllers::Documents
  class Delete
    include Admin::Action

    def call(params)
      Analytics.record_access(current_user(session), params['id'], '/delete_document/:id', 'app admin')
      if !current_user(session).admin
        Analytics.record_access(current_user(session), params['id'], '/delete_document/:id', 'app admin, unauthorized access')
        redirect_to '/error/0?An error occurred'
      end
      id = params['id']
      puts "Admin, Delete, id = #{id}".red
      DocumentRepository.destroy_tree(id, [:verbose, :kill])
      redirect_to '/admin/documents'
    end
  end
end
