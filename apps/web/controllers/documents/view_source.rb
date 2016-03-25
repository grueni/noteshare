require 'keen'
require_relative '../../../../lib/modules/analytics'
require_relative '../../../../lib/noteshare/interactors/read_document'

module Web::Controllers::Documents
  class ViewSource
    include Web::Action
    include Keen

    expose :document, :root_document, :updated_text, :current_image,:active_item, :active_item2, :view_options

    def call(params)

      @view_options =  {stem: 'view_source'}

      puts "Enter: ViewSource".red
      @active_item = 'reader'
      @active_item2 = 'source'

      result = ReadDocument.new(params, current_user2).call
      handle_error(result.error)
      @document = result.document
      @root_document = result.root_document


      if session['current_image_id']
        @current_image = ImageRepository.find session['current_image_id']
      end


      remember_user_view('source', session)
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
