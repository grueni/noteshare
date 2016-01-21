module Editor::Controllers::Document
  class AddPdf
    include Editor::Action

    expose :document
    expose :parent_document, :active_item, :create_mode


    def call(params)
      redirect_if_not_signed_in('editor, doc, add pdf')
      puts "controller AddPdf".red
      @active_item = 'editor'

      @create_mode = request.query_string
      puts "(1) query: #{request.query_string}".cyan
      @document = DocumentRepository.find params[:id]
      @parent_document = @document.parent_document

    end
  end
end
