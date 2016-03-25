require_relative '../../../../lib/modules/analytics'
require_relative '../../../../lib/noteshare/interactors/read_document'

module Web::Controllers::Documents
  class Aside
    include Web::Action
    include Analytics

    expose :document, :root_document, :aside, :active_item, :active_item2, :view_options

    def call(params)

      @view_options =  {stem: 'aside'}
      @active_item = 'reader'
      @active_item2 = 'sidebar'

      result = ReadDocument.new(params, current_user2).call
      handle_error(result.error)
      @document = result.document
      @root_document = result.root_document

      @aside = @document.associated_document('aside')
      ContentManager.new(@aside).update_content if @aside && @aside.content

      session[:current_document_id] = @document.id
      remember_user_view('sidebar', session)

      query_string = request.query_string || ''
      if query_string != ''
        redirect_to "/document/#{document_id}\##{query_string}"
      end

    end

  end
end
