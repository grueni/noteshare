require_relative '../../../../lib/noteshare/modules/subdomain'
include Noteshare::Subdomain

module Editor::Controllers::Document
  class UpdateToc
    include Editor::Action

    expose :document_id

    def call(params)
      id = session['current_document_id']
      @document_id = id
      data = request.query_string
      permutation = data.split(',').map{ |x| x.to_i }
      document = DocumentRepository.find id
      redirect_to "/editor/document/#{document.id}" if document.toc.count == 0

      TOCManager.new(document).permute_table_of_contents(permutation)
      document.root_document.compiled_dirty = true
      DocumentRepository.update document
      redirect_to basic_link "#{current_user2.screen_name}", "/editor/document/#{id}"
    end

  end
end
