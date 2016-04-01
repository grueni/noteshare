require_relative '../../../../lib/noteshare/interactors/read_document'


module Web::Controllers::Documents
  class ShowCompiled
    include Web::Action
    include Analytics

    expose :root_document, :document, :toc, :view_options
    expose :active_item, :active_item2

    def call(params)

      @view_options =  {stem: 'compiled'}
      @active_item = 'reader'
      @active_item2 = 'compiled'

      result = ReadDocument.new(params, current_user2).call
      handle_error(result.error)
      @document = result.document
      @root_document = result.root_document

      session[:current_document_id] = document.id

      options = {numbered: true, format: 'adoc-latex', xlinks: 'internalize', root_document_id: @root_document.id}
      cm = ContentManager.new(@root_document, options)
      cm.compile_with_render_lazily

      session[:current_document_id] = @root_document.id
      remember_user_view('compiled', session)

      if @root_document.dict['make_index'] # && false
        index_content = @root_document.dict['document_index']
        ## add new associated document of type index if necessary
        if @root_document.associated_document('index') == nil
          AssociateDocumentManager.new(@root_document).add(title: 'Index', type: 'index', rendered_content: index_content)
        else
          @root_document.associated_document('index').rendered_content = index_content
        end
      end

      DocumentRepository.update @root_document

    end

  end
end
