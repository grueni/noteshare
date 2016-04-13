require 'lotus/interactor'
require_relative '../../../modules/analytics'
require_relative '../../../../lib/noteshare/classes/document/toc_presenter'

module Noteshare
  module Interactor
    module Document
      class ReadDocument

        include Lotus::Interactor
        expose :document, :root_document, :rendered_content, :associated_document_mapper,
               :rendered_aside_content, :table_of_contents, :redirect_path

        def initialize(params, user, reader_type='document')
          @user = user
          # The reader type is one of: 'document', 'aside', 'compiled', 'view_source', 'titlepage'
          @reader_type = reader_type
          id = params['id']
          @document = DocumentRepository.find(id)
          if @document == nil
            @redirect_path = "/error?Document #{id} not found"
          end
        end

        def validated
          return false if @error
          world_permission = @document.acl_get(:world)
          if @user == nil && !(world_permission =~ /r/)
            @error = 'Unauthorized'
            return false
          else
            return true
          end
        end

        def configure_root_document
          if @document == nil
            @error ='document not found'
          else
            @root_document = @document.root_document
          end
          if @document == @root_document and @document.rendered_content and @document.rendered_content == ''
            @document = @document.first_section
          end
        end

        def call
          return if @redirect_path
          return unless validated
          configure_root_document
          ContentManager.new(@document).update_content
          DocumentActivityManager.new(@user).record(@document) if @user
          Analytics.record_document_view(@user, @document)
          prepare_rendered_content
          prepare_aside if @reader_type == 'aside'
          prepare_root_document if @reader_type == 'compiled'
          prepare_title_page if @reader_type == 'titlepage'
          prepare_table_of_contents
          @associated_document_mapper = Noteshare::Presenter::Document::AssociateDocMapper.new(@document)
        end

        def prepare_rendered_content
          ContentManager.new(@document).update_content if @document && @document.content
          if @document.rendered_content and @document.rendered_content != ''
            @rendered_content = @document.rendered_content
            if @document.is_root_document?
              @rendered_content = @rendered_content.sub('<h2 id="_index">Index</h2>', '')
            end
          else
            @rendered_content = "<p style='margin:3em;font-size:24pt;'>This block of the document is blank.  Please edit it or go to the next block</p>"
          end
        end

        def prepare_root_document
          options = {numbered: true, format: 'adoc-latex', xlinks: 'internalize', root_document_id: @root_document.id}
          cm = ContentManager.new(@root_document, options)
          cm.compile_with_render_lazily
          options = {numbered: true, format: 'adoc-latex', xlinks: 'internalize', root_document_id: @root_document.id}
          cm = ContentManager.new(@root_document, options)
          cm.compile_with_render_lazily
          options = {numbered: true, format: 'adoc-latex', xlinks: 'internalize', root_document_id: @root_document.id}
          cm = ContentManager.new(@root_document, options)
          cm.compile_with_render_lazily

          if @root_document.dict['make_index'] # && false
            index_content = @root_document.dict['document_index']
            ## add new associated document of type index if necessary
            if @root_document.associated_document('index') == nil
              Noteshare::Core::Document::AssociateDocumentManager.new(@root_document).add(title: 'Index', type: 'index', rendered_content: index_content)
            else
              @root_document.associated_document('index').rendered_content = index_content
            end
          end

          DocumentRepository.update @root_document
        end


        def prepare_table_of_contents
          case @reader_type
            when 'show' ,'aside'
              @table_of_contents = TOCPresenter.new(@document.root_document).root_table_of_contents(@document.id, @reader_type)
            when 'view_source'
              @table_of_contents = TOCPresenter.new(@document.root_document).root_table_of_contents(@document.id, @reader_type)
            when 'compiled'
              @table_of_contents = TOCPresenter.new(@root_document).internal_table_of_contents(['root', 'titlepage', 'sectnums', 'skip_first_item'], { doc_id: @root_document.id })
            when 'titlepage'
              @table_of_contents = TOCPresenter.new(@root_document).internal_table_of_contents(['root', 'titlepage', 'sectnums', 'skip_first_item'], { doc_id: @root_document.id })
            else
              @table_of_contents = TOCPresenter.new(@document.root_document).root_table_of_contents(@document.id, 'document')
          end
        end

        def prepare_title_page
          cm = ContentManager.new(@root_document, {numbered: true, format: 'adoc-latex'})
          cm.compile_with_render
          @root_document.compiled_content = ContentManager.new(@root_document).compile
        end

        def prepare_aside
          @aside = @document.associated_document('aside')
          if @aside && @aside.content
            ContentManager.new(@aside).update_content
            @rendered_aside_content = @aside.rendered_content
          else
            @rendered_aside_content = ''
          end
        end


      end
    end
  end
end

