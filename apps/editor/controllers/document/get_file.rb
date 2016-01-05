module Editor::Controllers::Document
  class GetFile
    include Editor::Action


    def get_document
      object_name = "#{@document.identifier}.txt"
      str = AWS.get_string(object_name, 'test')
      self.body = str
    end

    def call(params)
      id = params[:id]
      @document = DocumentRepository.find id
      if @document
        puts "Gettind document #{id} (#{@document.title})".red
        get_document
      else
        puts "Error; file #{id} not found"
      end


    end
  end
end
