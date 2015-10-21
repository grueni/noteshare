# apps/web/controllers/books/create.rb
module Editor::Controllers::Documents
  class Create
    include Editor::Action

    expose :document

    def call(params)
      puts "CREATE with params #{params[:document]}"
      @document = DocumentRepository.create(NSDocument.new(params[:document]))

      redirect_to '/documents'
    end
  end
end