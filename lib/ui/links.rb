require_relative '../../lib/noteshare/modules/tools'
require_relative '../../lib/acl'

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
    include Noteshare::Tools
    include ACL

    #####################################################
    #
    #  1. SESSION LINKS
    #  2. APPLICATION-WIDE LINKS
    #  3. DOCUMENT LINKS
    #  4. ADMIN LINKS
    #  5. OTHER LINKS
    #
    #####################################################

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


    def domain_link
      domain = ENV['DOMAIN']
      if domain
        domain.sub(/^\./,'')
      else
        'localhost'
      end

    end


    def home_link(active_item='')
      if active_item == 'home'
        link_to html.img(src: '/images/earth_green.png', title: 'system home', style: 'margin-top:-4px'), '/home'
      else
        link_to html.img(src: '/images/earth_white.png', title: 'system home', style: 'margin-top:-4px'), '/home'
      end
    end

    def current_user_node_link(session, active_item='')
      user = current_user(session)
      return '' if user == nil
      if active_item == 'node'
        link_to html.img(src: '/images/home_green.png', title: 'user home', style: 'margin-top:-4px'), "/node/user/#{user.id}"
      else
        link_to html.img(src: '/images/home_white.png', title: 'user home', style: 'margin-top:-4px'), "/node/user/#{user.id}"
      end
    end

    def node_link(node)
      link_to node.name, "/node/#{node.id}"
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
    #   3. READER LINKS
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


    def compiled_document_link(document, active_item2='')
      if active_item2 == 'compiled'
        return link_to 'Compiled', "/compiled/#{document.id}", class: 'active_item2'
      else
        return  link_to 'Compiled', "/compiled/#{document.id}", class: 'item2'
      end
    end


    def titlepage_link(document, active_item2='')
      if active_item2 == 'titlepage'
        return link_to 'Title Page', "/titlepage/#{document.id}", class: 'active_item2'
      else
        return  link_to 'Title Page', "/titlepage/#{document.id}", class: 'item2'
      end
    end

    def titlepage_link2(document, active_item2='')
      if active_item2 == 'titlepage'
        return link_to document.title, "/titlepage/#{document.id}", class: 'active_item2'
      else
        return  link_to document.title, "/titlepage/#{document.id}", class: 'item2'
      end
    end

    def compiled_root_document_link(document)
      doc = document.root_document
      link_to doc.title, "/compiled/#{doc.id}"
    end

    def iconic_compiled_document_link(document)
      image_link('/images/books8.png', "/compiled/#{document.id}")
    end

    def standard_document_link(document, active_item2='')
      if active_item2 == 'standard'
        return link_to 'Chunked', "/document/#{document.id}", class: 'active_item2'
      else
        return  link_to 'Chunked', "/document/#{document.id}", class: 'item2'
      end
    end

    def aside_document_link(document, active_item2='')
      if active_item2 == 'aside'
        return link_to 'Aside', "/aside/#{document.id}", class: 'active_item2'
      else
        return  link_to 'Aside', "/aside/#{document.id}", class: 'item2'
      end
    end

    def documents_link(active_item='')
      if active_item == 'documents'
        return link_to 'Directory', "/documents", class: 'active_item'
      else
        return  link_to 'Directory', "/documents"
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


    def share_document_link(document)
      #  html.tag(:a, 'Share', href: '#')
      image_link('/images/share.png', '#', 'share document #')
    end



    #####################################################
    #
    #   3. EDITOR LINKS
    #
    #####################################################

    def export_link(document)
      # link_to 'Export', "/editor/export/#{document.id}"
      image_link '/images/export.png', "/editor/export/#{document.id}", "export document #"
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

    def new_document_link
        # html.tag(:a, 'New document', href: '/editor/new')
      image_link'/images/new_document.png', '/editor/new', 'new_document'
    end

    def new_section_link(document)
      #   html.tag(:a, 'New section', href: "/editor/new_section/#{document.id}")
      image_link '/images/new_section.png', "/editor/new_section/#{document.id}?child", 'new section (child)'
    end

    def new_sibling_before_link(document)
      image_link '/images/add_left.png', "/editor/new_section/#{document.id}?sibling_before", 'new section before'
    end

    def new_sibling_after_link(document)
      image_link '/images/add_right.png', "/editor/new_section/#{document.id}?sibling_after", 'new section after'
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
      # html.tag(:a, 'Delete document', href: '#')
      image_link('/images/delete_document.png', "/editor/prepare_to_delete_document/#{document.id}?tree", 'delete document')
    end

    def delete_section_link(document)
      image_link('/images/delete_section.png', "/editor/prepare_to_delete_document/#{document.id}?section", 'delete section')
    end

    def publish_document_link(document)
      if document.root_document.acl_get(:world) =~ /r/
        image_link('/images/publish_document_green.png', "#", 'publish/unpbublish document')
      else
        image_link('/images/publish_document_blue.png', "#", 'publish/unpbublish document')
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
      image_link '/images/section_settings.png', "#", 'section settings #'
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