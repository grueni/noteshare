require_relative '../../../../lib/modules/analytics'

module Web::Controllers::Documents
  class ShowCompiled
    include Web::Action
    include Analytics

    expose :root_document, :document, :toc
    expose :active_item, :active_item2

    def call(params)
      puts "controller: ShowCompiled".red
      @active_item = 'reader'
      @active_item2 = 'compiled'
      @document = DocumentRepository.find(params['id'])
      handle_nil_document(@document, params['id'])
      session[:current_document_id] = document.id
      @root_document = document.root_document
      @root_document.compile_with_render_lazily({numbered: true, format: 'adoc-latex'})

      Analytics.record_page_visit(current_user(session), @root_document)

      if @root_document.dict['make_index'] # && false
        index_content = @root_document.dict['document_index']
        if @root_document.associated_document('index') == nil
          @root_document.add_associate(title: 'Index', type: 'index', rendered_content: index_content)
        else
          @root_document.associated_document('index').rendered_content = index_content
        end
      end

      DocumentRepository.update @root_document

    end

  end
end
