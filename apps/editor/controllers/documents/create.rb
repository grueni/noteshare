require_relative '../../../../lib/noteshare/interactors/editor/create_document'

module Editor::Controllers::Documents
  class Create
    include Editor::Action
    include Noteshare::Interactor::Document
    include NSDocument::Asciidoc

    expose :document

    def call(params)
      result = CreateDocument.new(params, current_user2).call
      redirect_to result.redirect_path if result.error
      @document = result.document
      redirect_to result.redirect_path
    end

  end
end