# apps/web/controllers/books/create.rb
module Editor::Controllers::Documents
  class Create
    include Editor::Action

    expose :document

    def call(params)

      @document = DocumentRepository.create(NSDocument.new(params[:document]))
      @document.update_content
      @document.compile_with_render

      redirect_to '/documents'
    end
  end
end