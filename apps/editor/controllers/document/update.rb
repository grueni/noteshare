module Editor::Controllers::Document
  class Update
    include Editor::Action

    expose :document

    def call(params)
      document_packet = params.env['rack.request.form_hash']['document']

      new_text = document_packet['updated_text'].gsub('\\r', '')
      puts
      puts 'new_text (1)'
      puts  new_text
      puts
      id = document_packet.keys[1].sub(':', '')
      @document = DocumentRepository.find(id)
      @document.update_content new_text
      @document.compile_with_render
      redirect_to "/editor/document/#{id}"
    end

  end
end
