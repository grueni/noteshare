module Editor::Controllers::Document
  class MiniEdit
    include Editor::Action
    include Noteshare::Interactor::Document
    include ::Noteshare::Presenter::Document
    include ::Noteshare::Core::Image

    expose :document, :parent_document, :root_document, :updated_text, :mapper,
           :current_image, :active_item, :editors

    def call(params)
      @active_item = 'editor'
      id = params['id']

      result = EditDocument.new(params, current_user2).call
      @document = result.document
      @root_document= result.root_document
      @parent_document = @document.parent_document
      @updated_text = result.updated_text
      @editors = result.editors
      @mapper = AssociateDocMapper.new(@document)

      session['current_document_id'] = @document.id

      if session['current_image_id']
        @current_image = ImageRepository.find session['current_image_id']
      end

      # self.body = "HOLA! id = #{id}"

    end

  end
end
