module Editor::Controllers::Document
  class Export
    include Editor::Action

    expose :document, :active_item

    def call(params)
      redirect_if_not_signed_in('editor, document, Export')
     @active_item = 'editor'
     puts "EDTIOR EXPORT".magenta
     puts "ID: #{params[:id]}".red
      # self.body = 'OK'
      @document = DocumentRepository.find params[:id]

      ContentManager.new(@document).
                                       
      redirect_to "http://vschool.s3.amazonaws.com/latex/#{@document.id}.tar"
    end

  end
end
