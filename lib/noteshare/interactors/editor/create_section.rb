require 'lotus/interactor'

module Noteshare
  module Interactor
    module Document
      class CreateSection

        include Lotus::Interactor
        include Noteshare::Core
        expose :new_document, :error

        def initialize(params)
          document_packet = params['document']
          @title = document_packet['title']
          @content = document_packet['content']
          @create_mode = document_packet['create_mode'] || 'sibling_below'
          current_document_id = document_packet['current_document_id']
          @current_document = DocumentRepository.find current_document_id
          @author_credentials = @current_document.author_credentials2
          @error = nil
        end

        def validate_document
          if @title == nil or @title == ''
            @error = '/error/:0?Please enter a title for the new section'
          end
        end

        def configure
          if @current_document.is_root_document?
            @create_mode = 'child'
          end
        end

        def create
          @new_document = NSDocument.create(title: @title, content: @content, author_credentials: @author_credentials)
          #Fixme: the following line is to be deleted when author_id is retired
          @new_document.author_id = @author_credentials['id'].to_i
          @new_document.acl = @current_document.root_document.acl

          ContentManager.new(@new_document).update_content(nil)
          DocumentRepository.update @new_document
        end

        def attach
          @parent_document = @current_document.parent_document

          if @create_mode == 'child'
            document_manager = DocumentManager.new(@current_document)
          else
            document_manager = DocumentManager.new(@parent_document)
          end

          case @create_mode
            when 'child'
              document_manager.append(@new_document)
            when 'sibling_above'
              document_manager.add_as_sibling(new_sibling: @new_document, direction: :before, old_sibling: @current_document)
            when 'sibling_below'
              document_manager.add_as_sibling(new_sibling: @new_document, direction: :after, old_sibling: @current_document)
            else
              puts 'do nothing'
          end

        end

        def call
          validate_document
          configure
          create
          attach
        end

      end
    end
  end
end

