module UI

  #####################################################
  #
  #  1. MODULE LINKS
  #  2. MODULE FORS
  #
  #####################################################


  module Links
    require_relative '../../lib/user_authentication'
    include SessionTools

    #####################################################
    #
    #  1. SESSION LINKS
    #  2. APPLICATION-WIDE LINKS
    #  3. DOCUMENT LINKS
    #  4. OTHER LINKS
    #
    #####################################################


    def image_link(image, link)
      "<a href='#{link}'><img src='images/#{image}'></a>"
    end

    #####################################################
    #
    #   1. SESSION LINKS
    #
    #####################################################

    def signin_link
      link_to 'Sign in', '/session_manager/login'
    end

    def signup_link
      link_to 'Sign up', '/session_manager/new_user'
    end

    def signout_link
      link_to 'Sign out', '/session_manager/logout'
    end

    def admin_link
      link_to 'Admin', '/admin'
    end

    #####################################################
    #
    #   APPLICATION-WIDE LINKS
    #
    #####################################################


    def home_link
      image_link('earth.png', '/')
    end

    def current_user_node_link(session)
      user = current_user(session)
      if user
        image_link('home_white.png', "/node/user/#{user.node_id}")
        # link_to "#{user.screen_name.capitalize}", "/node/user/#{user.node_id}"
      else
        puts "No current user".red
      end
    end


    #####################################################
    #
    #   3. DOCUMENT LINKS
    #
    #####################################################



    def document_link(document)
      link_to document.title, "/document/#{document.id}"
    end

    def documents_link
      link_to 'Documents', '/documents'
    end

    def export_link(document)
      link_to 'Export', "/editor/export/#{document.id}"
    end

    def editor_link(session)
      if session['current_doc_id']
        current_document = DocumentRepository.find session[:current_doc_id]
        link_to 'Editor', "/editor/document/#{current_document.id}"
      else
        ''
      end
    end

    def new_document_link
        html.tag(:a, 'New', href: '/editor/new')
    end

    def reader_link(session)
      if session['current_doc_id']
        current_document = DocumentRepository.find session[:current_doc_id]
        link_to 'Reader', "/document/#{current_document.id}"
      else
        ''
      end
    end

    def current_document_link(session)
      if session['current_doc_id']
        current_document = DocumentRepository.find session[:current_doc_id]
        link_to current_document.title, "/document/#{current_document.id}"
      end
    end




    #####################################################
    #
    #   4. OTHER LINKS
    #
    #####################################################

    def settings_link(document)
      link_to "Settings", "/editor/document/options/#{document.id}"
    end



  end

  module Forms

    def search_form

      form_for :search, '/search' do
        label 'Search for:'
        text_field :search, {style: 'inline-display;'}
      end

    end

  end
end