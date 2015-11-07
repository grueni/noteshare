module Editor::Controllers::Document
  class Edit
    include Editor::Action

    expose :document
    expose :updated_text


    def call(params)
      puts ">> Editor edit".red
      puts "XXXX: params[:id] = #{params[:id]}"
      @document = DocumentRepository.find(params['id'])
      session[:current_doc_id] = @document.id
      puts 'SESSION:'.magenta
      puts session.inspect.cyan
      @updated_text = @document.content
    end

  end
end
