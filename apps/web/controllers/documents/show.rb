

module Web::Controllers::Documents
  class Show
    include Web::Action

    expose :document


    def call(params)
      @document = DocumentRepository.find(params['id'])
      session[:current_doc_id] = @document.id
      puts 'SESSION (in Web (Reader):'.magenta
      puts session.inspect.cyan
      @document.update_content
    end

  end
end
