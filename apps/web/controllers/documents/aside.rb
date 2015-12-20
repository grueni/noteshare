module Web::Controllers::Documents
  class Aside
    include Web::Action

    expose :document, :aside, :active_item, :active_item2

    def call(params)

      document_id = params['id']
      query_string = request.query_string || ''

      @active_item = 'reader'
      @active_item2 = 'aside'
      @document = DocumentRepository.find(document_id)
      @aside = @document.associated_document('aside')

      session[:current_document_id] = document_id

      @document.update_content
      @aside.update_content if @aside && @aside.content

      if query_string != ''
        redirect_to "/document/#{document_id}\##{query_string}"
      end

    end

  end
end
