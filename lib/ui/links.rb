module UI

  #####################################################
  #
  #  1. MODULE LINKS
  #  2. MODULE FORMS
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
    #  4. ADMIN LINKS
    #  5. OTHER LINKS
    #
    #####################################################


    def image_link2(image, link)
      "<a href='#{link}'><img src='images/#{image}'></a>"
    end

    def image_link(image_path, url, title='')
      link_to html.img(src: image_path, title: title), url
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

    def welcome_link(session)
      user = current_user(session)
      if user
        "Welcome back, #{user.screen_name}"
      else
        ''
      end
    end



    #####################################################
    #
    #   APPLICATION-WIDE LINKS
    #
    #####################################################


    def home_link(active_item='')
      if active_item == 'home'
        image_link('/images/earth_red.png', '/')
      else
        image_link('/images/earth.png', '/')
      end
    end

    def current_user_node_link(session, active_item='')
      user = current_user(session)
      puts "active_item = #{active_item}".red
      return '' if user == nil
      if active_item == 'node'
        image_link('/images/home_red.png', "/node/user/#{user.id}")
      else
        image_link('/images/home_white.png', "/node/user/#{user.id}")
      end
    end



    #####################################################
    #
    #   3. DOCUMENT LINKS
    #
    #####################################################

    def admin_link(active_item='')
      if active_item == 'admin'
        return link_to 'Admin', '/admin', class: 'active_item'
      else
        return  link_to 'Admin', '/admin'
      end
    end

    def document_link(document)
      link_to document.title, "/document/#{document.id}"
    end

    def documents_link(active_item='')
      link_to 'Documents', '/documents'
      if active_item == 'documents'
        return link_to 'Documents', "/documents", class: 'active_item'
      else
        return  link_to 'Documents', "/documents"
      end
    end

    def export_link(document)
      # link_to 'Export', "/editor/export/#{document.id}"
      image_link '/images/export.png', "/editor/export/#{document.id}"
    end

    def editor_link(session, active_item='')
      return '' if session == nil
      _id = session['current_document_id']
      # puts "In editor link, session['current_document_id'] = #{session['current_document_id']} ".magenta
      return '' if _id == nil
      if active_item == 'editor'
        return link_to 'Editor', "/editor/document/#{_id}", class: 'active_item'
      else
        return  link_to 'Editor', "/editor/document/#{_id}"
      end

    end


    def reader_link(session, active_item='')
      return '' if session == nil
      _id = session['current_document_id']
      return '' if _id == nil
      if active_item == 'reader'
        return link_to 'Reader', '#', class: 'active_item'
      else
        return  link_to 'Reader', "/document/#{_id}"
      end

    end

    def new_document_link
        # html.tag(:a, 'New document', href: '/editor/new')
      image_link'/images/new_document.png', '/editor/new', 'new_document'
    end

    def new_section_link(document)
      #   html.tag(:a, 'New section', href: "/editor/new_section/#{document.id}")
      image_link '/images/new_section.png', "/editor/new_section/#{document.id}", 'new section'
    end

    def new_associated_document_link(document)
      #   html.tag(:a, 'New section', href: "/editor/new_section/#{document.id}")
      image_link '/images/site.png', "/editor/new_associated_document/#{document.id}", 'new section'
    end


    def delete_document_link(document)
      # html.tag(:a, 'Delete document', href: '#')
      image_link('/images/delete_document.png', "/editor/prepare_to_delete_document/#{document.id}", 'delete document')
    end

    def delete_section_link(document)
      # html.tag(:a, 'Delete section', href: '#')
      image_link('/images/delete_section.png', "#", 'delete section')
    end

    def publish_document_link(document)
      image_link('/images/publish_document.png', "#", 'publish document')
    end

    def publish_section_link(document)
      image_link('/images/publish_section.png', "#", 'publish section')
    end

    def check_in_out_link(document)
      # html.tag(:a, 'Check in/out', href: '#')
      image_link('/images/check_in_out.png', '#', 'check document out')
    end

    def share_document_link(document)
     #  html.tag(:a, 'Share', href: '#')
      image_link('/images/share.png', '#', 'share document')
    end

    def edit_toc_link(document)
      image_link('/images/edit_toc.png', '#', 'rearrange table of contents')
    end

    def image_manager_link(active_item='')
      if active_item == 'images'
        html.tag(:a, 'Images', href: '/image_manager/search', class: 'active_item')
      else
        html.tag(:a, 'Images', href: '/image_manager/search')
      end

    end



    def current_document_link(session)
      if session['current_document_id']
        current_document = DocumentRepository.find session[:current_document_id]
        link_to current_document.title, "/document/#{current_document.id}"
      end
    end

    #####################################################
    #
    #   4. ADMIN LINKS
    #
    #####################################################

   def update_message_link
     link_to 'Edit system message', '/admin/update_message'
   end


    #####################################################
    #
    #   5. OTHER LINKS
    #
    #####################################################


    def user_settings_link
      image_link '/images/gears.png', '/session_manager/settings', 'user settings'
    end

    def settings_link(document)
      # link_to "Settings", "/editor/document/options/#{document.id}"
      image_link '/images/document_settings.png', "/editor/document/options/#{document.id}", 'document settings'
    end

    def section_settings_link(document)
      # link_to "Settings", "/editor/document/options/#{document.id}"
      image_link '/images/section_settings.png', "#", 'section settings'
    end

    #####################################################
    #
    #   6. OTHER
    #
    #####################################################

    def right_footer_text
      "❤ Knowledge"
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