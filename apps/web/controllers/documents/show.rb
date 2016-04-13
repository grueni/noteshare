
require 'keen'
require_relative '../../../../lib/noteshare/interactors/editor/read_document'

module Web::Controllers::Documents
  class Show
    include Web::Action
    include Noteshare::Interactor::Document

    expose :document, :root_document, :payload,
           :active_item, :active_item2,  :view_options

    def call(params)
      @active_item = 'reader'
      @active_item2 = 'standard'
      @view_options =  {stem: 'document'}

      @payload = ReadDocument.new(params, current_user2).call
      redirect_to_path @payload.redirect_path
      handle_error(@payload.error)
      @document = @payload.document
      @root_document = @payload.root_document

      session[:current_document_id] = @document.id
      remember_user_view('standard', session)

      query_string = request.query_string || ''
      if query_string != ''
        redirect_to "/document/#{document_id}\##{query_string}"
      end
    end
  end
end
