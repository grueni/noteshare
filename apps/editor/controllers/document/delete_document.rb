  module Editor::Controllers::Document
  class DeleteDocument
    include Editor::Action

    expose :active_item

    def call(params)
      puts "controler DeleteDocument".red

      @active_item = 'editor'
      user = current_user(session)
      control =  params['document']['destroy']
      doc_id =  params[:id]
      @delete_mode = params['document']['delete_mode']
      puts "DELETE MODE #{@delete_mode}".red
      @document = DocumentRepository.find doc_id
      message = ''

      puts "HERE (1,2)".red


      if control != 'destroy'
        message << "You did not say 'destroy'"
        redirect_to "/editor/document/#{doc_id}"
      end

      puts "HERE (3)".red

      return if Permission.new(user, :delete,  @document) == false

      puts "HERE (4)".red

      if @delete_mode == 'section'
        puts "HERE (5a)".red
        @document.delete
        node = user.node
        node.update_docs_for_owner
        message << "#{@document.title} has been deleted."
        redirect_to "/editor/document/#{@parent.id}"
      end

      if @delete_mode == 'tree'
        puts "HERE (5b)"
        DocumentRepository.destroy_tree @document.id, [:verbose, :kill]
        message << "#{@document.title} and it entrie document tree has been deleted."
        redirect_to "/node/user/#{current_user(session).id}"
      end

    end
  end
end
