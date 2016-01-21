require_relative '../../../../lib/acl'

module Editor::Controllers::Document
  class PublishAll
    include Editor::Action

    expose :document, :active_item

    def call(params)
      redirect_if_not_signed_in('editor, document, PublishAll')
      puts "controller PublishAll".red
      @active_item = 'editor'
      document = DocumentRepository.find params[:id]
      ACL.toggle_world_readable_for_tree(document)
      redirect_to "/editor/document/#{params[:id]}"
      end

  end
end
