require_relative '../../../../lib/noteshare/modules/ns_document_asciidoc'
include NSDocument::Asciidoc

module Editor::Controllers::Document
  class Update
    include Editor::Action

    expose :document

    def call(params)
      puts ">> Editor update".red

      document_packet = params['document']
      id = document_packet['document_id'].to_i
      new_text = document_packet['updated_text']

      @document = DocumentRepository.find(id)
      @document.update_content new_text
      @document.compile_with_render
      @document.synchronize_title

      redirect_to "/editor/document/#{id}"
    end

  end
end
