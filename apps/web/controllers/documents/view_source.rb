require 'keen'
require_relative '../../../../lib/noteshare/interactors/editor/read_document'

module Web::Controllers::Documents
  class ViewSource
    include Web::Action
    include Noteshare::Interactor::Document
    include ::Noteshare::Core::Document

    expose :document, :root_document, :updated_text, :payload,
           :current_image,:active_item, :active_item2, :view_options

    def call(params)

      @view_options =  {stem: 'view_source'}

      puts "Enter: ViewSource".red
      @active_item = 'reader'
      @active_item2 = 'source'

      @payload = ReadDocument.new(params, current_user2, 'view_source').call
      redirect_to_path @payload.redirect_path

      handle_error(@payload.error)
      @document = @payload.document
      @root_document = @payload.root_document

      if session['current_image_id']
        @current_image = ImageRepository.find session['current_image_id']
      end

      remember_user_view('source', session)
      session[:current_document_id] = @document.id

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
