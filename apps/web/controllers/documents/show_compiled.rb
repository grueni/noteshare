require_relative '../../../../lib/noteshare/interactors/editor/read_document'


module Web::Controllers::Documents
  class ShowCompiled
    include Web::Action
    include Noteshare::Interactor::Document

    expose :root_document, :document, :payload, :view_options
    expose :active_item, :active_item2

    def call(params)

      @view_options =  {stem: 'compiled'}
      @active_item = 'reader'
      @active_item2 = 'compiled'

      @payload = ReadDocument.new(params, current_user2, 'compiled').call
      redirect_to_path @payload.redirect_path

      handle_error(@payload.error)
      @document = @payload.document
      @root_document = @payload.root_document

      session[:current_document_id] = document.id
      session[:current_document_id] = @root_document.id
      remember_user_view('compiled', session)

    end

  end
end
