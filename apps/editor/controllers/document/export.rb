module Editor::Controllers::Document
  class Export
    include Editor::Action
    include ::Noteshare::Core::Document

    expose :document, :active_item

    def call(params)
      @active_item = 'editor'
      @document = DocumentRepository.find params[:id]
      ContentManager.new(@document).export
      redirect_to "/document/#{params[:id]}"
    end

  end
end
