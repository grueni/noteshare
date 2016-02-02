require_relative '../../../../lib/modules/analytics'

module Web::Controllers::Documents
  class Aside
    include Web::Action
    include Analytics

    expose :document, :root_document, :aside, :active_item, :active_item2

    def call(params)

      document_id = params['id']
      query_string = request.query_string || ''

      @active_item = 'reader'
      @active_item2 = 'sidebar'
      @document = DocumentRepository.find(document_id)
      handle_nil_document(@document, document_id)

      @root_document = @document.root_document
      if @document.content.length < 3
        @document = @document.subdocument(0)
        handle_nil_document(@document, document_id)
      end

      session[:current_document_id] = document_id

      ContentManager.new(@document).update_content
      ContentManager.new(@aside).update_content if @aside && @aside.content

      session[:current_document_id] = @document.id

      Analytics.record_document_view(current_user(session), @document)

      if query_string != ''
        redirect_to "/document/#{document_id}\##{query_string}"
      end

    end

  end
end
