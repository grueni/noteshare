require_relative '../../../../lib/modules/analytics'
require_relative '../../../../lib/noteshare/interactors/editor/read_document'

module Web::Controllers::Documents
  class Aside
    include Web::Action
    include Noteshare::Interactor::Document

    expose :document, :root_document, :payload, :active_item, :active_item2, :view_options

    def call(params)

      @view_options =  {stem: 'aside'}
      @active_item = 'reader'
      @active_item2 = 'sidebar'

      redirect_to_path @payload.redirect_path

      handle_error(@payload.error)
      @document = @payload.document
      @root_document = @payload.root_document

      session[:current_document_id] = @document.id
      remember_user_view('sidebar', session)

      query_string = request.query_string || ''
      if query_string != ''
        redirect_to "/document/#{document_id}\##{query_string}"
      end

    end

  end
end
