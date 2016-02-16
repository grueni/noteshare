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
    require_relative '../../lib/noteshare/modules/subdomain'
    include SessionTools
    include Noteshare::Tools
    include ACL
    include Noteshare::Subdomain

    #####################################################
    #
    #  1. SESSION LINKS
    #  2. APPLICATION-WIDE LINKS
    #  3. DOCUMENT LINKS
    #  4. ADMIN LINKS
    #  5. OTHER LINKS
    #
    #####################################################

    def document_index_link(document, session)
      user = current_user(session)
      if user
        text_link(title: 'Index', prefix: user.screen_name, suffix: "compiled/#{document.id}\#_index")
      else
        ''
      end
    end


    def image_link(image_path, url, title='')
      link_to html.img(src: image_path, title: title), url
    end

    # image_link2(prefix: :none, suffix: 'home', image: '/images/earth.png', 'system home')
    def image_link2(hash)
      style = hash['style'] || 'margin-top:-4px'
      basic_url = basic_link(hash[:prefix], hash[:suffix])
      link_to html.img(src: hash[:image], title: hash[:title], style: style), basic_url
    end

    # text_link()
    def text_link(hash)
      css_class = hash[:class] || ''
      css_style = hash[:style] || ''
      link_to hash[:title], basic_link(hash[:prefix], hash[:suffix]), class: css_class, css_style: css_style
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



    #####################################################
    #
    #   APPLICATION-WIDE LINKS
    #
    #####################################################


    def current_domain_name
      ENV['DOMAIN'].sub(/^\./,'')
    end

    def home_link(session, active_item='')
      active_item == 'home' ? image = '/images/earth_green.png' : image = '/images/earth_white.png'
      puts "In home link, session = #{session.inspect}".cyan
      cu = current_user(session)
      if cu
        puts "in home_link, user = #{cu.full_name}".red
        image_link2(prefix: cu.node_name, suffix: 'home', title: 'system home', image: image)
      else
        puts "in home_link,NO USER".red
        image_link2(prefix: :none, suffix: 'home', title: 'system home', image: image)
      end
    end

    def current_user_node_link(session, active_item='')
      user = current_user(session)
      return '' if user == nil
      active_item == 'home' ? image = '/images/home_green.png' : image = '/images/home_white.png'
      image_link2(prefix: user.node_name, suffix: "node/user/#{user.node_id}", title: 'user home', image: image)
    end

    def node_link1(node, session)
      text_link(prefix: node.name, suffix: "node/#{node.id}", title: node.name)
    end

    def node_link(node, session)
      # cu = current_user(session)
      # cu ? prefix = cu.node_name : prefix = node.name
      user = current_user(session)
      if user
        prefix = user.screen_name
      else
        prefix = node.name
      end
      text_link(prefix: prefix, suffix: "node/#{node.id}", title: node.name)
    end

    def user_node_link(user)
      link_to user.screen_name, "/node/#{user.node_id}"
    end

    def current_node_link(session, active_item='')
      cu = current_user(session)
      return ''  if cu == nil
      node_name = cu.get_current_node_name
      node_id = cu.get_current_node_id

      if node_id
        node = NSNodeRepository.find node_id
      end
      return '' if node == nil

      if cu
        prefix = cu.screen_name
      else
        prefix = node_name
      end

      active_item == 'node' ? image = '/images/node_green.png' : image = '/images/node_white.png'
      image_link2(prefix:prefix, suffix: "node/#{node.id}", title: 'current node', image: image)
    end

    def image_manager_link(active_item='')
      if active_item == 'images'
        html.tag(:a, 'Images', href: '/image_manager/search', class: 'active_item')
      else
        html.tag(:a, 'Images', href: '/image_manager/search')
      end

    end

    def admin_link(session, active_item='')
      active_item == 'admin' ? css_class = 'active_item' : ''
      cu = current_user(session)
      return ''  if cu == nil
      text_link(title: 'Admin', prefix: cu.node_name , suffix: 'admin', class: css_class)
    end

    def admin_analytics_link(session, active_item='')
      active_item == 'admin' ? css_class = 'active_item' : ''
      cu = current_user(session)
      return ''  if cu == nil
      text_link(title: 'Analytics', prefix: cu.node_name , suffix: 'admin/analytics', class: css_class)
    end


    def current_document_link(session)
      if session['current_document_id']
        current_document = DocumentRepository.find session[:current_document_id]
        link_to current_document.title, "/document/#{current_document.id}"
      end
    end

    def guide_link_long(session)
      # cu = current_user(session)
      # cu ? prefix = cu.node_name : prefix = :none
      # return text_link(prefix: prefix, suffix: "document/#{ENV['USER_GUIDE_DOC_ID']}", title: 'User Guide')
      link_to 'User Guide', "/document/#{ENV['USER_GUIDE_DOC_ID']}"
    end


    def guide_link(session)
      cu = current_user(session)
      cu ? prefix = cu.node_name : prefix = :none
      return text_link(prefix: prefix, suffix: "document/#{ENV['USER_GUIDE_DOC_ID']}", title: 'G', class: 'redlink;', style: 'font-weight: bold; margin-bottom:-4px;')
      # link_to "G",  "document/#{ENV['USER_GUIDE_DOC_ID']}",  class: 'redlink;', style: 'font-weight: bold; margin-bottom:-4px;'

    end

    def admin_manual_link_long(session)
      cu = current_user(session)
      cu ? prefix = cu.node_name : prefix = :none
      return text_link(prefix: prefix, suffix: "document/#{ENV['ADMIN_MANUAL_DOC_ID']}", title: "Administrator's manual")
      # link_to 'User Guide', "/document/#{ENV['USER_GUIDE_DOC_ID']}"
    end

    def admin_manual_link(session)
      cu = current_user(session)
      cu ? prefix = cu.node_name : prefix = :none
      return text_link(prefix: prefix, suffix: "document/#{ENV['ADMIN_MANUAL_DOC_ID']}", title: 'A', class: 'redlink;', style: 'font-weight: bold; margin-bottom:-4px;')
      # link_to "G",  "document/#{ENV['USER_GUIDE_DOC_ID']}",  class: 'redlink;', style: 'font-weight: bold; margin-bottom:-4px;'

    end

    #####################################################
    #
    #   3. READER LINKS
    #
    #####################################################



    def document_link(document)
      link_to document.title, "/document/#{document.id}"
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

    def titlepage_link2(document, active_item2='')
      if active_item2 == 'titlepage'
        return link_to document.title, "/titlepage/#{document.id}", class: 'active_item2'
      else
        return  link_to document.title, "/titlepage/#{document.id}", class: 'item2'
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

    def iconic_compiled_document_link(document)
      image_link('/images/books8.png', "/compiled/#{document.id}")
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


    def documents_link(session, active_item='')
      active_item == 'documents' ? css_class = 'active_item' : css_class = ''
      cu = current_user(session)
      if cu
        return text_link(prefix: cu.node_name, suffix: "documents", title: 'Directory', class: css_class)
      else
        return  text_link(prefix: :none, suffix: "documents", title: 'Directory', class: css_class)
      end
    end

    def reader_link(session, active_item='')
      return '' if session == nil
      # cu = current_user(session)
      # return '' if cu == nil
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
      cu = current_user(session)
      return '' if cu == nil
      _id = cu.dict2['current_document_id']
      return '' if _id == nil
      document = DocumentRepository.find _id
      return '' if document == nil
      cu = current_user(session)
      return '' if cu == nil
      return '' if Permission.is_not_given?(cu, :edit, document)
      if active_item == 'editor'
        return link_to 'Editor', "/editor/document/#{_id}", class: 'active_item'
      else
        return  link_to 'Editor', "/editor/document/#{_id}"
      end
    end

    def edit_document_link(session, document_id)
      link_to 'Back to editor', basic_link("#{current_user(session).screen_name}",   "editor/document/#{document_id}")
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



    #####################################################
    #
    #   4. ADMIN LINKS
    #
    #####################################################

   def update_message_link
     link_to 'Edit system message', '/admin/update_message'
   end

   def delete_user_link(id)
     link_to 'delete', "/admin/delete_user/#{id}"
   end

    def admin_delete_document_link(id)
      link_to 'delete', "/admin/delete_document/#{id}"
    end

    def edit_node_link(id)
      link_to 'edit', "/node/edit/#{id}"
    end

    def remove_document_from_node_link(document_id)
      link_to 'remove', "/node/remove_document/#{document_id}"
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



    #####################################################
    #
    #   5. OTHER LINKS
    #
    #####################################################

    def node_link_for_document(document)
      publisher_data = document.dict['publisher']
      return '--' if publisher_data == nil
      publisher_list = publisher_data.to_pair_list || []
      if publisher_list != []
          name, id = publisher_list[0]
        link_to name, "/node/#{id}"
      else
        '--'
      end
    end


    def user_settings_link
      image_link '/images/gears.png', '/session_manager/settings', 'user settings'
    end

    def settings_link(document)
      image_link '/images/document_settings.png', "/editor/document/options/#{document.id}?root", 'document settings'
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


    #####################################################
    #
    #   6. OTHER
    #
    #####################################################

    def right_footer_text
      "❤ Knowledge"
    end

    #####################################################
    #
    #   7. RADIO BUTTONS
    #
    #####################################################




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