# apps/web/controllers/books/create.rb
module Editor::Controllers::Documents
  class Create
    include Editor::Action

    expose :document

    def call(params)
      puts "CCCC: CREATE with params #{params.to_s}"
      puts "CCCC: CREATE with params #{params[:document].to_s}"
      @document = DocumentRepository.create(NSDocument.new(params[:document]))

      redirect_to '/documents'
    end
  end
end