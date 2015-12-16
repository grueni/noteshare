  module Editor::Controllers::Document
  class DeleteDocument
    include Editor::Action

    expose :active_item

    def call(params)

      @active_item = 'editor'
      user = current_user(session)
      control =  params['document']['destroy']
      doc_id =  params[:id]
      @delete_mode = params['document']['delete_mode']
      puts "DELETE MODE #{@delete_mode}".red
      @document = DocumentRepository.find doc_id
      message = ''

      if @document.is_root_document?
        message << "#{@document.title} has been deleted."
        redirect_to "/editor/document/#{doc_id}"
      else
        @parent = @document.parent_document
      end

      if control != 'destroy'
        message << "You did not say 'destroy'"
        redirect_to "/editor/document/#{doc_id}"
      end

      return if Permission.new(user, :delete,  @document) == false

      if @delete_mode == 'section'
        @document.delete
        node = user.node
        node.update_docs_for_owner
        message << "#{@document.title} has been deleted."
        redirect_to "/editor/document/#{@parent.id}"
      end

    end
  end
end
