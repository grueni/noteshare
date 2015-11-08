

module Web::Controllers::Documents
  class Show
    include Web::Action

    expose :document


    def call(params)
      @document = DocumentRepository.find(params['id'])
      session[:current_doc_id] = @document.id
      @document.update_content
    end

  end
end
