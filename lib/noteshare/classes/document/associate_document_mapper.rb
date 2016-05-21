require 'pry'

module Noteshare
  module Presenter
    module Document

      class AssociateDocMapper

        ## PUBLIC ##

        def initialize(document)
          @document = document
        end


        def root_associated_document_map
          root = @document.root_document || @document
          if root != @document
            adm = AssociateDocMapper.new(root)
            adm.associated_document_map
          else
            associated_document_map
          end
        end

        def associated_document_map

          heal_associated_docs

          if @document.type =~ /associated:/
            document = @document.parent_document
          else
            document = @document
          end

          hash = document.doc_refs2 || {}
          ids = hash.keys
          if ids
            map = "<ul>\n"
            ids.each do |id|
              document = DocumentRepository.find id
              if document
                if id == @document.id.to_s
                  map << '<li>' << "#{document.title}</li>\n"
                else
                  map << '<li>' << "<a href='/editor/mini_edit/#{id}' >#{document.title}</li>\n"
                end
              end
            end
            map << "</ul>\n"
          else
            map = ''
          end
          map
        end


        ## PRIVATE ##

        private

        # Remove stale keys
        # Fixme: this will become obsolete
        # when things are working better
        def heal_associated_docs
          bad_keys = []
          @document.doc_refs do |key, value|
            if DocumentRepository.find key == nil
              bad_keys << key
            end
          end
          bad_keys.each do |key|
            @document.doc_refs.delete(key)
          end
          DocumentRepository.update @document
        end




        # INTERNAL
        def associate_link(type, prefix='')
          if prefix == ''
            "<a href='/document/#{@document.doc_refs[type]}'>#{type.capitalize}</a>"
          else
            "<a href='/#{prefix}/document/#{@document.doc_refs[type]}'>#{type.capitalize}</a>"
          end

        end


      end
    end
  end
end

