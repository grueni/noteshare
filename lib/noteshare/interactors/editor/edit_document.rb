require 'lotus/interactor'
require_relative '../../../modules/analytics'

module Noteshare
  module Interactor
    module Document
      class EditDocument

        include Lotus::Interactor
        include ::Noteshare::Core::Document


        expose :document, :root_document, :updated_text, :editors, :redirect_path, :associated_document_mapper

        def initialize(params, user)
          id = params['id']
          @document = DocumentRepository.find(id)
          if @document
            @root_document = @document.root_document
            @user = user
          else
            @redirect_path = "/error?Document #{id} not found"
          end
        end


        def call
          return unless @document
          # Do not edit document root in the regular editor
          if @document.is_root_document?
            first_section = @document.first_section
            id = first_section.id if first_section
          end

          @user.dict2['current_document_id'] = id
          UserRepository.update @user
          Analytics.record_edit(@user, @document)


          cm = ContentManager.new(@document)
          if @document.is_root_document?
            cm.compile_with_render_lazily
          else
            cm.update_content_lazily
          end
          @updated_text = @document.content

          es = Noteshare::EditorStatus.new(@document)
          @editors = "Editors: #{es.editor_array_string_value}"
          es.add_editor(@user)

          if ['compiled', 'titlepage'].include? @user.dict2['reader_view']
            @user.dict2['reader_view'] = 'sidebar'
            UserRepository.update @user
          end
          @associated_document_mapper = Noteshare::Presenter::Document::AssociateDocMapper.new(@document)
        end

      end
    end
  end
end

