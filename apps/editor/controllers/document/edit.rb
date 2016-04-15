
require_relative '../../../../lib/noteshare/interactors/editor/edit_document'

module Editor::Controllers::Document
  class Edit
    include Editor::Action
    include Noteshare::Interactor::Document
    include ::Noteshare::Core::Image

    expose :document, :root_document, :updated_text, :current_image, :active_item, :editors, :result

    def call(params)
      @active_item = 'editor'

      @result = EditDocument.new(params, current_user2).call
      redirect_to_path result.redirect_path

      @document = @result.document
      @root_document= @result.root_document
      @updated_text = @result.updated_text
      @editors = @result.editors

      session['current_document_id'] = @document.id

      if session['current_image_id']
        @current_image = ImageRepository.find session['current_image_id']
      end
    end

  end
end
