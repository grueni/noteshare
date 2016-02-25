require 'keen'
require_relative '../../../../lib/modules/analytics'

module Web::Controllers::Documents
  class ViewSource
    include Web::Action
    include Keen

    expose :document, :root_document, :updated_text, :current_image,:active_item, :active_item2

    def call(params)
      puts "Enter: ViewSource".red
      user = current_user(session)
      id = params['id']

      if session['current_image_id']
        @current_image = ImageRepository.find session['current_image_id']
      end

      @active_item = 'reader'
      @active_item2 = 'source'
      @document = DocumentRepository.find(id)
      handle_nil_document(@document, params['id'])
      redirect_if_document_not_public(@document, 'Unauthorized attempt to read document that is not world-readable')

      @root_document = @document.root_document
      if @document.content.length < 3
        @document = @document.subdocument(0)
        handle_nil_document(@document, id)
      end
      remember_user_view('source', session)
      Analytics.record_document_view(user, @document)
      session[:current_document_id] = id

      cm = ContentManager.new(@document)
      if @document.is_root_document?
        cm.compile_with_render_lazily
      else
        cm.update_content_lazily
      end
      @updated_text = @document.content
    end
  end
end
