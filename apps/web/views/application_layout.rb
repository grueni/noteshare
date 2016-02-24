

module Web
  module Views
    class ApplicationLayout
      include Web::Layout
      # include Web::Assets::Helpers
      require_relative '../../../lib/ui/links'
      require_relative '../../../lib/noteshare/modules/subdomain'
      include Noteshare::Subdomain
      include UI::Links
      include UI::Forms

      def mathjax_script(doc)
        if doc and doc.render_options['format']
           "http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"
        else
          ''
        end
      end


      #####################################################
      #
      #   1. SESSION LINKS
      #
      #####################################################

      def signin_link
        puts 'SIGNIN_LINK'.red
        link_to 'Sign in', '/session_manager/login'
      end

      def signup_link
        link_to 'Sign up', '/session_manager/new_user'
      end

      def signout_link
        link_to 'Sign out', '/session_manager/logout'
      end

      def welcome_link(session)
        user = current_user(session)
        if user
          "Welcome back, #{user.screen_name}"
        else
          ''
        end
      end

      def guide_link_long(session)
        # cu = current_user(session)
        # cu ? prefix = cu.node_name : prefix = :none
        # return text_link(prefix: prefix, suffix: "document/#{ENV['USER_GUIDE_DOC_ID']}", title: 'User Guide')
        link_to 'User Guide', "/document/#{ENV['USER_GUIDE_DOC_ID']}"
      end

      def print_document_link(session, active_item2)
        user = current_user(session)
        document = DocumentRepository.find session['current_document_id']
        return 'X' if user == nil or document == nil
        if active_item2 == 'compiled'
          route = "viewer/print/#{document.id}?root"
        else
          route = "viewer/print/#{document.id}?section"
        end
        image_link2(prefix: user.node_name, suffix: route, title: 'print document', image: '/images/printer_white.png')
      end


      def compiled_document_link(document, active_item2='')
        if active_item2 == 'compiled'
          return link_to 'C', "/compiled/#{document.id}", class: 'active_item2', title: 'view compiled document'
        else
          return  link_to 'C', "/compiled/#{document.id}", class: 'item2black', title: 'view compiled document'
        end
      end

      def titlepage_link(document, active_item2='')
        if active_item2 == 'titlepage'
          return link_to 'T', "/titlepage/#{document.id}", class: 'active_item2', title: 'view titlepage'
        else
          return  link_to 'T', "/titlepage/#{document.id}", class: 'item2black', title: 'view titlepage'
        end
      end

      def compiled_root_document_link(document)
        root_doc = document.root_document
        if document == root_doc
          link_to root_doc.title, "/compiled/#{root_doc.id}"
        else
          link_to document.title, "/document/#{document.id}"
        end
      end


      def standard_document_link(document, active_item2='')
        if active_item2 == 'standard'
          return link_to 'B', "/document/#{document.id}", class: 'active_item2', title: 'view by block'
        else
          return  link_to 'B', "/document/#{document.id}", class: 'item2black', title: 'view by block'
        end
      end

      def aside_document_link(document, active_item2='')
        if active_item2 == 'sidebar'
          return link_to 'S', "/aside/#{document.id}", class: 'active_item2', title: 'display sidebar'
        else
          return  link_to 'S', "/aside/#{document.id}", class: 'item2black', title: 'display sidebar'
        end
      end

      def source_document_link(document, active_item2='')
        if active_item2 == 'source'
          return link_to 'X', "/view_source/#{document.id}", class: 'active_item2', title: 'view source'
        else
          return  link_to 'X', "/view_source/#{document.id}", class: 'item2black', title: 'view source'
        end
      end

    end
  end
end
