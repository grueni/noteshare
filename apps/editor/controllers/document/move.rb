module Editor::Controllers::Document
  class Move
    include Editor::Action

    expose :active_item

    def call(params)
      @active_item = 'editor'
      doc_id =  params[:id]
      query_string = request.query_string

      puts "QUERY STRING; #{query_string}".red

      @document = DocumentRepository.find doc_id

      case query_string
        when 'move_to_parent_level'
          new_parent = @document.move_section_to_parent_level
          redirect_to "/editor/document/#{new_parent.id}"
        when 'move_up_in_toc'
          @document.move_up_in_toc
          redirect_to "/editor/document/#{@document.id}"
        when 'move_down_in_toc'
          @document.move_down_in_toc
          redirect_to "/editor/document/#{@document.id}"
      end

      # redirect_to '/'

    end

  end
end
