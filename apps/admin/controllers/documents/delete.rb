module Admin::Controllers::Documents
  class Delete
    include Admin::Action

    def call(params)
      redirect_if_not_admin('Attempt to delete document (admin, documents, delete)')
      id = params['id']
      redirect_if_not_admin("Attempt to delete document #{id}: (admin, documents, delete)")
      puts "Admin, Delete, id = #{id}".red
      DocumentRepository.destroy_tree(id, [:verbose, :kill])
      redirect_to '/admin/search'
    end
  end
end
