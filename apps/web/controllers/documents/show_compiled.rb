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
      redirect_if_document_not_public(@document, 'Unauthorized attempt to read document that is not world-readable')


      session[:current_document_id] = document.id
      @root_document = @document.root_document
      ContentManager.new(@root_document).compile_with_render_lazily({numbered: true,
                                                                     format: 'adoc-latex', xlinks: 'internalize'})

      session[:current_document_id] = @root_document.id

      Analytics.record_document_view(current_user(session), @root_document)

      if @root_document.dict['make_index'] # && false
        adm = AssociateDocManager.new(@root_document)
        index_content = @root_document.dict['document_index']
        if adm.associated_document('index') == nil
          AssociateDocManager.new(@root_document).add_associate(title: 'Index', type: 'index', rendered_content: index_content)
        else
          adm.associated_document('index').rendered_content = index_content
        end
      end

      DocumentRepository.update @root_document

    end

  end
end
