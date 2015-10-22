module Editor::Controllers::Document
  class Update
    include Editor::Action

    expose :document

    def call(params)
      puts
      puts
      document_packet = params.env['rack.request.form_hash']['document']
      puts "UUU: document_packet = #{document_packet}"
      new_text = document_packet['updated_text']
      id = document_packet.keys[1].sub(':', '')
      puts "id = #{id}"
      @document = DocumentRepository.find(id)
      puts "UUU: @document.title #{@document.title}"
      @document.update_content new_text
      @document.compile_with_render
      self.body = 'OK'
      # redirect_to "/document/:#{id}"
      redirect_to "/editor/document/#{id}"
    end

  end
end
