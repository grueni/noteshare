

module Web::Controllers::Documents
  class Show
    include Web::Action

    expose :document
    expose :active_item


    def call(params)


      document_id = params['id']
      query_string = request.query_string || ''


      @active_item = 'reader'
      @document = DocumentRepository.find(document_id)
      session[:current_document_id] = @document.id

      puts @document.is_root_document?
      puts query_string.blue
      puts document_id.blue


      if @document.is_root_document?
        @document.compile_with_render
      else
        @document.update_content
      end

      if query_string != ''
        puts "REDIRECTNG".red
        redirect_to "/document/#{document_id}\##{query_string}"
      else
        puts "NOT REDIRECTNG".red
      end

      # http://localhost:2300/documents/287#__differential_equations_with_regular_singular_points
      # http://localhost:2300/document/283#_monodromy
      # http://localhost:2300/documents/283#_monodromy
      # http://localhost:2300/documents/287#_more_stuff

    end
  end
end
