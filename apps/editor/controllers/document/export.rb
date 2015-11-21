module Editor::Controllers::Document
  class Export
    include Editor::Action

    expose :document

    def call(params)
     puts "EDTIOR EXPORT".magenta
     puts "ID: #{params[:id]}".red
      # self.body = 'OK'
      @document = DocumentRepository.find params[:id]
      @document.export
      redirect_to "/document/#{params[:id]}"
    end

  end
end
