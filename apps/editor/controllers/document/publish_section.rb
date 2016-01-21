require_relative '../../../../lib/acl'

module Editor::Controllers::Document
  class PublishSection
    include Editor::Action

    expose :document, :active_item

    def call(params)
      redirect_if_not_signed_in('editor, document, PublishSection')
      puts "controller PublishSection".red
      @active_item = 'editor'
      document = DocumentRepository.find params[:id]
      ACL.toggle_world_readable(document)
      redirect_to "/editor/document/#{params[:id]}"
    end

  end
end
