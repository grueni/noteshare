module Editor::Controllers::Document
  class Update
    include Editor::Action

    expose :document

    def call(params)
      puts "UUUU: params[:id] = #{params[:id]}"
      @document = DocumentRepository.find(params['id'])
      self.body = 'OK'
      redirect_to '/documents'
    end

  end
end
