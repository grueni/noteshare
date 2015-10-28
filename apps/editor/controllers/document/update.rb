require_relative '../../../../lib/noteshare/modules/ns_document_asciidoc'
include NSDocument::Asciidoc

module Editor::Controllers::Document
  class Update
    include Editor::Action

    expose :document

    def call(params)
      document_packet = params.env['rack.request.form_hash']['document']

      new_text = document_packet['updated_text']   # .gsub('\\r', '')
      puts
      puts 'new_text (1)'
      puts  new_text
      puts
      new_text =  new_text  # .gsub("\n     ", '')
      puts  new_text
      puts
      id = document_packet.keys[1].sub(':', '')
      @document = DocumentRepository.find(id)
      @document.update_content new_text
      @document.compile_with_render
      @document.synchronize_title

      redirect_to "/editor/document/#{id}"
    end

  end
end
