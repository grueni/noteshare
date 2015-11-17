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


    def image_link2(image, link)
      "<a href='#{link}'><img src='images/#{image}'></a>"
    end

    def image_link(image_path, url)
      link_to html.img(src: image_path), url
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
      link_to 'No account?  click here', '/session_manager/new_user'
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

    def admin_link
      link_to 'Admin', '/admin'
    end

    #####################################################
    #
    #   APPLICATION-WIDE LINKS
    #
    #####################################################


    def home_link
      image_link('images/earth.png', '/')
    end

    def current_user_node_link(session)
      #Fixme: simplify
      user = current_user(session)
      return '' if user == nil
       #  node = NSNodeRepository.for_owner_id(user.id)
      # return '' if node == nil
      image_link('images/home_white.png', "/node/user/#{user.id}")
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
      return '' if session == nil
      _id = session['current_document_id']
      # puts "In editor link, session['current_document_id'] = #{session['current_document_id']} ".magenta
      return '' if _id == nil
      link_to 'Editor', "/editor/document/#{_id}"
    end


    def reader_link(session)
      return '' if session == nil
      _id = session['current_document_id']
      return '' if _id == nil
      return link_to 'Reader', "/document/#{_id}"
    end

    def new_document_link
        html.tag(:a, 'New document', href: '/editor/new')
    end

    def new_section_link(document)
      html.tag(:a, 'New section', href: '#')
    end


    def delete_document_link(document)
      html.tag(:a, 'Delete document', href: '#')
    end

    def delete_section_link(document)
      html.tag(:a, 'Delete section', href: '#')
    end

    def publish_document_link(document)
      html.tag(:a, 'Publish document', href: '#')
    end

    def publish_section_link(document)
      html.tag(:a, 'Publish section', href: '#')
    end

    def check_in_out_link(document)
      html.tag(:a, 'Check in/out', href: '#')
    end

    def share_document_link(document)
      html.tag(:a, 'Share', href: '#')
    end

    def edit_toc_link(document)
      html.tag(:a, 'Edit TOC', href: '#')
    end

    def image_manager_link
      html.tag(:a, 'Images', href: '/image_manager/search')
    end



    def current_document_link(session)
      if session['current_document_id']
        current_document = DocumentRepository.find session[:current_document_id]
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

      def basic_search_form
        form_for :search, '/search' do
          text_field :search, id: 'basic_search_form'
        end
      end

    end

  end
end