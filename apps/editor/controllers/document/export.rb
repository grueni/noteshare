module Editor::Controllers::Document
  class Export
    include Editor::Action

    expose :document, :active_item

    def call(params)
     @active_item = 'editor'
     puts "EDTIOR EXPORT".magenta
     puts "ID: #{params[:id]}".red
      # self.body = 'OK'
      @document = DocumentRepository.find params[:id]
      @document.export
      redirect_to "/document/#{params[:id]}"
    end

  end
end
