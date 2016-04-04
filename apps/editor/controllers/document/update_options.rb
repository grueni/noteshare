require_relative '../../../../lib/noteshare/interactors/editor/update_document_options'

module Editor::Controllers::Document
  class UpdateOptions
    include Editor::Action

    expose :document, :active_item

    def call(params)
      @active_item = 'editor'
      result = UpdateDocumentOptions.new(params).call
      @document = result.document
      redirect_to result.redirect_path
    end

  end
end
