

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
      handle_nil_document(@document, document_id)
      session[:current_document_id] = document_id

      @document.update_content

      cu = current_user(session)
      if cu
        Keen.publish(:document_views, { :username => cu.screen_name,
                                        :document => @document.title, :document_id => @document.id })
      else
        Keen.publish(:document_views, { :username => 'anonymous',
                                        :document => @document.title, :document_id => @document.id })
      end

      if query_string != ''
        redirect_to "/document/#{document_id}\##{query_string}"
      end

    end
  end
end
