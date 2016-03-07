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
      if user && !document.is_associated_document?
        text_link(title: 'Index', prefix: user.screen_name, suffix: "compiled/#{document.id}\#_index")
      else
        ''
      end
    end

    def image_link(image_path, url, title='')
      link_to html.img(src: image_path, title: title), url
    end

    # text_link()
    def text_link(hash)
      css_class = hash[:class] || ''
      css_style = hash[:style] || ''
      link_to hash[:title], basic_link(hash[:prefix], hash[:suffix]), class: css_class, css_style: css_style
    end

    #####################################################
    #
    #   APPLICATION-WIDE LINKS
    #
    #####################################################

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
      active_item == 'home' ? image = '/images/home_green.png' : image = '/images/home_red.png'
      image_link2(prefix: user.node_name, suffix: "node/user/#{user.node_id}", title: 'user home', image: image)
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


    def current_node_link(session, active_item='')
      cu = current_user(session)
      return ''  if cu == nil
      nam = NodeActivityManager.new(user: cu)
      nam .configure
      last_node_id = nam.last_node_id
      last_node_name = nam.last_node_name

      if cu
        prefix = cu.screen_name
      else
        prefix = last_node_name
      end

      active_item == 'node' ? image = '/images/node_green.png' : image = '/images/node_white.png'
      image_link2(prefix:prefix, suffix: "node/#{last_node_id}", title: 'current node', image: image)
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

    def guide_link(session)
      cu = current_user(session)
      cu ? prefix = cu.node_name : prefix = :none
      return text_link(prefix: prefix, suffix: "aside/#{ENV['USER_GUIDE_DOC_ID']}", title: 'User Guide', class: 'redlink;', style: 'font-weight: bold; margin-bottom:-4px;')
      # link_to "G",  "document/#{ENV['USER_GUIDE_DOC_ID']}",  class: 'redlink;', style: 'font-weight: bold; margin-bottom:-4px;'

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
        return  link_to 'Reader', "/choose_view/#{_id}"
      end

    end


    #####################################################
    #
    #   3. READER LINKS
    #
    #####################################################




    def titlepage_link2(document, active_item2='')
      if active_item2 == 'titlepage'
        return link_to document.title, "/titlepage/#{document.id}", class: 'active_item2'
      else
        return  link_to document.title, "/titlepage/#{document.id}", class: 'item2'
      end
    end

    #666

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


    #####################################################
    #
    #   6. OTHER
    #
    #####################################################

    def right_footer_text
      "❤ Knowledge"
    end

    ######################################################
    #   7. RADIO BUTTONS
    #
    #####################################################

    def settings_link(document)
      image_link '/images/document_settings.png', "/editor/document/options/#{document.id}?root", 'document settings'
    end

    def share_document_link(document)
      #  html.tag(:a, 'Share', href: '#')
      image_link('/images/share.png', '#', 'share document #')
    end


    def new_document_link
      # html.tag(:a, 'New document', href: '/editor/new')
      image_link'/images/new_document.png', '/editor/new', 'new_document'
    end

    def remove_document_from_node_link(document_id)
      link_to 'remove', "/node/remove_document/#{document_id}"
    end

    ##########

    def edit_node_link(id)
      link_to 'edit', "/node/edit/#{id}"
    end

    private

    # image_link2(prefix: :none, suffix: 'home', image: '/images/earth.png', 'system home')
    def image_link2(hash)
      style = hash['style'] || 'margin-top:-4px'
      basic_url = basic_link(hash[:prefix], hash[:suffix])
      link_to html.img(src: hash[:image], title: hash[:title], style: style), basic_url
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