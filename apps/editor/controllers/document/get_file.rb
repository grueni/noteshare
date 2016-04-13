module Editor::Controllers::Document
  class GetFile
    include Editor::Action
    include Noteshare::Core::Document


    def get_new_document_text
      object_name = "#{@document.identifier}.txt"
      str = AWS.get_string(object_name, 'test')
      @document.content = str
      ContentManager.new(@document).update_content
      redirect_to "/editor/document/#{@document.id}"
    end

    def call(params)
      id = params[:id]
      @document = DocumentRepository.find id
      if @document
        puts "Getting  document #{id} (#{@document.title})".red
        get_new_document_text
      else
        puts "Error; file #{id} not found"
      end

    end
  end
end
