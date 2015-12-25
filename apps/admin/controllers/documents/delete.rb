module Admin::Controllers::Documents
  class Delete
    include Admin::Action

    def call(params)
      id = params['id']
      puts "Admin, Delete, id = #{id}".red
      DocumentRepository.destroy_tree(id, [:verbose, :kill])
      redirect_to '/admin/documents'
    end
  end
end
