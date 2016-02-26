module Editor
  module Views
    class ApplicationLayout
      include Editor::Layout
      require_relative '../../../lib/ui/links'
      include UI::Links

      def mathjax_script(doc)
        if doc and doc.render_options['format']
          "http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"
        else
          ''
        end
      end

      def export_link(document)
        # link_to 'Export', "/editor/export/#{document.id}"
        image_link '/images/export.png', "/editor/export/#{document.id}", "export document #"
      end

      #####################################################
      #
      #   3. EDITOR LINKS
      #
      #####################################################




      def edit_document_link(session, document_id)
        link_to 'Back to editor', basic_link("#{current_user(session).screen_name}",   "editor/document/#{document_id}")
      end

      def new_section_link(document)
        #   html.tag(:a, 'New section', href: "/editor/new_section/#{document.id}")
        image_link '/images/new_section.png', "/editor/new_section/#{document.id}?child", 'new section'
      end

      def add_pdf_link(document)
        image_link '/images/attach.png', "/editor/add_pdf/#{document.id}", 'new section with attached image or pdf file'
      end

      def new_associated_document_link(document)
        image_link '/images/site.png', "/editor/new_associated_document/#{document.id}", 'new associated document'
      end



      def move_section_to_level_of_parent_link(document)
        image_link '/images/move_to_parent_level.png', "/editor/move/#{document.id}/?move_to_parent_level", 'move section to level of parent'
      end

      def move_section_to_child_level_link(document)
        image_link '/images/move_to_child_level.png', "/editor/move/#{document.id}/?move_to_child_level", 'make section child of ...'
      end


      def move_up_in_toc_link(document)
        image_link '/images/move_up.png', "/editor/move/#{document.id}/?move_up_in_toc", 'move section up in toc'
      end


      def move_down_in_toc_link(document)
        image_link '/images/move_down.png', "/editor/move/#{document.id}/?move_down_in_toc", 'move section down in toc'
      end




      def delete_document_link(document)
        image_link('/images/delete_document.png', "/editor/prepare_to_delete_document/#{document.id}?tree", 'delete document')
      end

      def delete_section_link(document)
        image_link('/images/delete_section.png', "/editor/prepare_to_delete_document/#{document.id}?section", 'delete section')
      end

      def publish_document_link(document)
        if document.root_document.acl_get(:world) =~ /r/
          image_link('/images/publish_document_green.png', "/editor/publish_all/#{document.id}", 'publish/unpublish document')
        else
          image_link('/images/publish_document_blue.png', "/editor/publish_all/#{document.id}", 'publish/unpublish document')
        end
      end

      def publish_section_link(document)
        if document.acl_get(:world) =~ /r/
          image_link('/images/publish_section_green.png', "/editor/publish_section/#{document.id}", 'publish/unpublish section')
        else
          image_link('/images/publish_section_blue.png', "/editor/publish_section/#{document.id}", 'publish/unpublish section')
        end
      end

      def check_in_out_link(document)
        # html.tag(:a, 'Check in/out', href: '#')
        image_link('/images/check_in_out.png', '#', 'check document out #')
      end


      def edit_toc_link(document)
        image_link('/images/edit_toc.png', "/editor/edit_toc/#{document.id}", 'rearrange table of contents')
      end

      def upload_file_link
        link_to 'upload', "/uploader/file"
      end

      def get_document_link(document)
        link_to 'Get', "/editor/get/#{document.id}"
      end

      def put_document_link(document)
        link_to 'Put', "/editor/put/#{document.id}"
      end


      def section_settings_link(document)
        image_link '/images/section_settings.png', "/editor/document/options/#{document.id}?section", 'section settings'
      end



      def upload_image_link(option=nil)
        # session[:current_document_id] = document.id if document
        if option == nil
          image_link '/images/upload_image.png', "/uploader/image", 'upload image'
        else
          image_link '/images/upload_image.png', "/uploader/image?#{option}", 'upload image'
        end
      end

    end
  end
end
