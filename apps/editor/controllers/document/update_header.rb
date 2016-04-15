module Editor::Controllers::Document
  class UpdateHeader
    include Editor::Action
    include ::Noteshare::Core::Document

    def call(params)
      id = params[:id]
      document = (DocumentRepository.find id).root_document
      document_header = params['document_header']['header_content']
      document_header = "#{document_header.strip}\n\n"
      document.content_dirty = true
      ContentManager.new(document).update_content document_header
      document.synchronize_title unless document.dict['synchronize_title'] == 'no'
      redirect_to "/editor/document/#{id}"
    end
  end
end
