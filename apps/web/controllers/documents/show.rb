

module Web::Controllers::Documents
  class Show
    include Web::Action

    expose :document,  :active_item, :active_item2

    def call(params)

      document_id = params['id']
      query_string = request.query_string || ''

      @active_item = 'reader'
      @active_item2 = 'standard'
      @document = DocumentRepository.find(document_id)
      session[:current_document_id] = document_id

      if @document.is_root_document?
        @document.compile_with_render
      else
        @document.update_content
      end

      if query_string != ''
        redirect_to "/document/#{document_id}\##{query_string}"
      end

    end
  end
end
