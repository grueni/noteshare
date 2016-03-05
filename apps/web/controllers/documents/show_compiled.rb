require_relative '../../../../lib/modules/analytics'

module Web::Controllers::Documents
  class ShowCompiled
    include Web::Action
    include Analytics

    expose :root_document, :document, :toc, :view_options
    expose :active_item, :active_item2

    def call(params)

      @view_options =  {stem: 'compiled'}

      puts "controller: ShowCompiled".red
      @active_item = 'reader'
      @active_item2 = 'compiled'
      @document = DocumentRepository.find(params['id'])
      handle_nil_document(@document, params['id'])
      redirect_if_document_not_public(@document, 'Unauthorized attempt to read document that is not world-readable')

      session[:current_document_id] = document.id
      @root_document = @document.root_document

      options = {numbered: true, format: 'adoc-latex', xlinks: 'internalize', root_document_id: @root_document.id}
      cm = ContentManager.new(@root_document, options)
      cm.compile_with_render_lazily

      session[:current_document_id] = @root_document.id

      remember_user_view('compiled', session)
      cu = current_user(session)
      DocumentActivityManager.new(@document, cu).record
      Analytics.record_document_view(cu, @root_document)

      if @root_document.dict['make_index'] # && false
        index_content = @root_document.dict['document_index']
        ## add new associated document of type index if necessary
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
