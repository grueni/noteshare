

module Editor::Controllers::Document
  class UpdateToc
    include Editor::Action

    def call(params)

      puts "controller, UpdateToc".red

      data = request.query_string
      permutation = data.split(',').map{ |x| x.to_i }

      puts permutation.to_s.cyan

      puts  "session['current_document_id'] = #{session['current_document_id']}".red
      document = DocumentRepository.find session['current_document_id']
      redirect_to "editor/document/#{document.id}" if document.toc.count == 0


      document.permute_table_of_contents(permutation)

      self.body = "PERMUTATION = #{permutation}"

    end

    #Fixme: we really shouldn't do this
    #See: https://rubygems.org/gems/jquery-lotus
    private
    def verify_csrf_token?
      false
    end


  end
end
