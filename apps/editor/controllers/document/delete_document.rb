require_relative '../../../../lib/noteshare/interactors/editor/delete_ns_document'

module Editor::Controllers::Document
  class DeleteDocument
    include Editor::Action

    expose :active_item

    def call(params)
      @active_item = 'editor'
      result = DeleteNSDocument.new(params, current_user2).call
      redirect_to result.redirect_path
    end

  end
end
