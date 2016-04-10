require_relative '../../../../lib/noteshare/modules/ns_document_asciidoc'


module Editor::Controllers::Document
  class Update
    include Editor::Action
    include Noteshare::Core::Asciidoc

    expose :document, :active_item

    def call(params)
      @active_item = 'editor'
      puts "controller Editor update".red

      document_packet = params['document']
      id = document_packet['document_id'].to_i
      new_text = document_packet['updated_text']

      @document = DocumentRepository.find(id)
      ContentManager.new(@document).update_content new_text
      # if @document.is_root_document?
      #  @document.compile_with_render
      # end
      @document.synchronize_title unless @document.dict['synchronize_title'] == 'no'

      redirect_to "/editor/document/#{id}"
    end

  end
end
