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

    # Example: basic_link('code', 'foobar')
    # => "http://code.localhost:2300/foobar"
    # if ENV['HOST'] = '.localhost'
    #
    # Example: basic_link(:none, 'home')
    # => "http://scripta.io/home"
    # if ENV['HOST'] = 'scripta.io'
    #
    def basic_link(prefix, suffix)
      prefix == :none ? prefix = '' : prefix = "#{prefix}."
      suffix == :none ? suffix = '' : suffix = "/#{suffix}"
      stem = ENV['DOMAIN'].sub(/^\./,'')
      stem = "localhost:#{ENV['PORT']}" if stem == 'localhost'
      "http://#{prefix}#{stem}#{suffix}"
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
      link_to hash[:title], basic_link(hash[:prefix], hash[:suffix]), class: css_class
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


    def current_domain_name
      ENV['DOMAIN'].sub(/^\./,'')
    end

    def home_link(session, active_item='')
      active_item == 'home' ? image = '/images/earth_green.png' : image = '/images/earth_white.png'
      cu = current_user(session)
      if cu
        image_link2(prefix: cu.node_name, suffix: 'home', title: 'system home', image: image)
      else
        image_link2(prefix: :none, suffix: 'home', title: 'system home', image: image)
      end
    end

    def current_user_node_link(session, active_item='')
      user = current_user(session)
      return '' if user == nil
      active_item == 'home' ? image = '/images/home_green.png' : image = '/images/home_white.png'
      image_link2(prefix: user.node_name, suffix: "node/#{user.node_id}", title: 'system home', image: image)
    end

    def node_link1(node, session)
      text_link(prefix: node.name, suffix: "node/#{node.id}", title: node.name)
    end

    def node_link(node, session)
      cu = current_user(session)
      cu ? prefix = cu.node_name : prefix = node.name
      text_link(prefix: prefix, suffix: "node/#{node.id}", title: node.name)
    end

    def user_node_link(user)
      link_to user.screen_name, "/node/#{user.node_id}"
    end

    def current_node_link(session, active_item='')
      puts "current_node_link".red
      node_id = session['current_node_id']
      puts "current_node_id = #{node_id}".cyan
      if node_id
        node = NSNodeRepository.find node_id
      end
      return '' if node == nil
      puts "current node: #{node.name}".red
      active_item == 'node' ? image = '/images/node_green.png' : image = '/images/node_white.png'
      image_link2(prefix: node_name, suffix: "node/#{node.id}", title: 'current home', image: image)
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


    def upload_image_link
      image_link '/images/upload_image.png', "/uploader/image", 'upload image'
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