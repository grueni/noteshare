require_relative '../../../../lib/noteshare/modules/subdomain'
include Subdomain

module Editor::Controllers::Document
  class UpdateToc
    include Editor::Action

    expose :document_id

    def call(params)

      redirect_if_not_signed_in('editor, document, UpdateToc')
      id = session['current_document_id']
      @document_id = id
      data = request.query_string
      permutation = data.split(',').map{ |x| x.to_i }
      document = DocumentRepository.find id
      redirect_to "/editor/document/#{document.id}" if document.toc.count == 0

      TOCManager.new(document).permute_table_of_contents(permutation)
      document.root_document.compiled_dirty = true
      DocumentRepository.update document

      puts 'READY TO REDIRECT'.magenta
      # redirect_to "/editor/document/#{id}
      redirect_to basic_link "#{current_user(session)}.screen_name",   "/editor/document/#{id}"
      puts 'AFTER REDIRECT'.magenta
      # redirect_to "/"

    end

    #Fixme: we really shouldn't do this
    #See: https://rubygems.org/gems/jquery-lotus
    private
    def verify_csrf_token?
      false
    end


  end
end
