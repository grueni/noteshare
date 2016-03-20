module Web::Controllers::Document
  class ChooseView
    include Web::Action

    def call(params)

      document_id = params['id']
      if document_id  == '0'
        document_id = session['current_document_id']
      end

      redirect_to "/document/#{document_id}" if current_user2 == nil

      reader_view = current_user2.dict2['reader_view'] || 'standard'

      case reader_view
        when 'sidebar'
          redirect_to "/aside/#{document_id}"
        when 'source'
          redirect_to "/view_source/#{document_id}"
        when 'compiled'
          redirect_to "/compiled/#{document_id}"
        when 'titlepage'
          redirect_to "/titlepage/#{document_id}"
        else
          redirect_to "/document/#{document_id}"
      end

    end
  end
end
