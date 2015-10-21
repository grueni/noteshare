module Editor::Controllers::Document
  class Edit
    include Editor::Action

    expose :document


    def call(params)
      puts "XXXX: params = #{params[:id]}"
      @document = DocumentRepository.find(params['id'])
    end
  end
end