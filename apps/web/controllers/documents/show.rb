
require 'keen'
require_relative '../../../../lib/modules/analytics'

module Web::Controllers::Documents
  class Show
    include Web::Action
    include Keen

    expose :document,  :active_item, :active_item2

    def call(params)

      document_id = params['id']
      query_string = request.query_string || ''


      @active_item = 'reader'
      @active_item2 = 'standard'
      @document = DocumentRepository.find(document_id)
      handle_nil_document(@document, document_id)
        session[:current_document_id] = document_id
        puts "web show, recording session[:current_document_id] as #{session[:current_document_id]}".red

      ContentManager.new(@document).update_content

      cu = current_user(session)

      Analytics.record_document_view(cu, @document)

      if query_string != ''
        redirect_to "/document/#{document_id}\##{query_string}"
      end

    end
  end
end
