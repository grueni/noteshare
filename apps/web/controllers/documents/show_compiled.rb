

module Web::Controllers::Documents
  class ShowCompiled
    include Web::Action

    expose :root_document, :toc
    expose :active_item, :active_item2

    def call(params)
      puts "controller: ShowCompiled".red
      @active_item = 'reader'
      @active_item2 = 'compiled'
      document = DocumentRepository.find(params['id'])
      session[:current_document_id] = document.id
      @root_document = document.root_document
      @root_document.compile_with_render({numbered: true, format: 'adoc-latex'})
      @root_document.compiled_content = @root_document.compile
      puts "@root_document.compiled_content: #{@root_document.compiled_content}".cyan
      DocumentRepository.update @root_document
      @toc = @root_document.internal_table_of_contents(:root)
    end

  end
end
