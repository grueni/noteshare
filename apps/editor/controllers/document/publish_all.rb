require_relative '../../../../lib/acl'

module Editor::Controllers::Document
  class PublishAll
    include Editor::Action

    expose :document, :active_item

    def call(params)
      @active_item = 'editor'
      document = DocumentRepository.find params[:id]
      root_document = document.root_document
      redirect_to '/error/0?root document not found' if root_document == nil
      ACL.toggle_world_readable_for_tree(root_document)
      redirect_to "/editor/document/#{params[:id]}"
      end
  end
end
