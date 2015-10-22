module Editor::Controllers::Document
  class Edit
    include Editor::Action

    expose :document
    expose :updated_text


    def call(params)
      puts "XXXX: params[:id] = #{params[:id]}"
      @document = DocumentRepository.find(params['id'])
      @updated_text = @document.content
    end

  end
end
