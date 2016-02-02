
require 'keen'
require_relative '../../../../lib/modules/analytics'

module Web::Controllers::Documents
  class Show
    include Web::Action
    include Keen

    expose :document, :root_document,  :active_item, :active_item2

    def call(params)

      document_id = params['id']
      query_string = request.query_string || ''


      @active_item = 'reader'
      @active_item2 = 'standard'
      @document = DocumentRepository.find(document_id)
      handle_nil_document(@document, document_id)

      @root_document = @document.root_document
      if @document.content.length < 3
        @document = @document.subdocument(0)
        handle_nil_document(@document, document_id)
      end

      session[:current_document_id] = document_id

      ContentManager.new(@document).update_content

      cu = current_user(session)

      Analytics.record_document_view(cu, @document)

      if query_string != ''
        redirect_to "/document/#{document_id}\##{query_string}"
      end

    end
  end
end
