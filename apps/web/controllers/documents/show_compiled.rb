module Web::Controllers::Documents
  class ShowCompiled
    include Web::Action

    expose :root_document

    def call(params)
      document = DocumentRepository.find(params['id'])
      session[:current_document_id] = document.id
      @root_document = document.root_document
      @root_document.compile_with_render({numbered: true, toc: true})
    end

  end
end
