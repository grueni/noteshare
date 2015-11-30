

module Web::Controllers::Documents
  class Show
    include Web::Action

    expose :document


    def call(params)

      @document = DocumentRepository.find(params['id'])
      puts @document.is_root_document?

      session[:current_document_id] = @document.id
=begin
      if @document.is_root_document?
        @document.compile_with_render
      else
        @document.update_content
      end
=end
    end
  end
end
