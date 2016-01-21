module Admin::Controllers::Documents
  class Delete
    include Admin::Action

    def call(params)
      Analytics.record_access(current_user(session), params['id'], '/delete_document/:id', 'app admin')
      redirect_if_not_admin('Attempt to delete document (admin, documents, delete)')
      id = params['id']
      puts "Admin, Delete, id = #{id}".red
      DocumentRepository.destroy_tree(id, [:verbose, :kill])
      redirect_to '/admin/documents'
    end
  end
end
