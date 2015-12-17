module Editor::Controllers::Document
  class Move
    include Editor::Action

    expose :active_item

    def call(params)
      @active_item = 'editor'
      doc_id =  params[:id]
      query_string = request.query_string

      @document = DocumentRepository.find doc_id

      case query_string
        when 'move_to_parent_level'
          new_parent = @document.move_section_to_parent_level
        when 'move_up_in_toc'
          new_parent = @document.move_up_in_toc
        when 'move_down_in_toc'
          new_parent = @document.move_down_in_toc
      end

      # redirect_to '/'
      redirect_to "/editor/document/#{new_parent.id}"
    end

  end
end
