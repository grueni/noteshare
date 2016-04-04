require_relative '../../../../lib/acl'

module Editor::Controllers::Document
  class PublishSection
    include Editor::Action

    expose :document, :active_item

    def call(params)
      @active_item = 'editor'
      document = DocumentRepository.find params[:id]
      ACL.toggle_world_readable(document)
      redirect_to "/editor/document/#{params[:id]}"
    end

  end
end
