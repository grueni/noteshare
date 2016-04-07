module Editor::Controllers::Document
  class Move
    include Editor::Action

    expose :active_item

    def call(params)
      @active_item = 'editor'
      doc_id =  params[:id]
      query_string = request.query_string

      @document = DocumentRepository.find doc_id
      if @document == nil
        redirect_to '/error:0?Document not found'
      end
      @tocManager = TOCManager.new(@document)

      case query_string
        when 'move_to_parent_level'
          # new_parent = @document.move_section_to_parent_level
          @tocManager.move_section_to_sibling_of_parent
        when 'move_to_child_level'
          @tocManager.make_child_of_sibling
        when 'move_up_in_toc'
          @tocManager.move_up_in_toc
        when 'move_down_in_toc'
          @tocManager.move_down_in_toc
      end
      redirect_to "/editor/document/#{@document.id}"
    end

  end
end
