module Editor::Controllers::Document
  class SendFile
    include Editor::Action

    # http://docs.aws.amazon.com/AmazonS3/latest/dev/UploadObjSingleOpRuby.html
    def send_document
      @object_name = "#{@document.identifier}.txt"
      puts "document id = #{@document.id}"
      @url = Noteshare::AWS.put_string(@document.content, "#{@document.identifier}.txt", 'test' )
    end

    def call(params)

      id = params[:id]
      @document = DocumentRepository.find id

      if @document
        send_document
        self.body = "OK: contents of #{@document.title} uploaded to #{@object_name} "
      else
        self.body = "ERROR: file (id = #{id}) not found"
      end

    end

  end
end
