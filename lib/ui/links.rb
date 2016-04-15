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
    require_relative '../noteshare/classes/document/document_activity_manager'
    include SessionTools
    include Noteshare::Tools
    include ACL
    include Noteshare::Subdomain
    include Noteshare::Helper::Document
    include ::Noteshare::Core::Document

    #####################################################
    #
    #  1. SESSION LINKS
    #  2. APPLICATION-WIDE LINKS
    #  3. DOCUMENT LINKS
    #  4. ADMIN LINKS
    #  5. OTHER LINKS
    #
    #####################################################

    def site_title
      ENV['DOMAIN'].sub('.','')
    end

    def document_index_link(document, session)
      user = current_user(session)
      prefix = get_prefix(session)
      if user && !document.is_associated_document?
        text_link(title: 'Index', prefix: prefix, suffix: "compiled/#{document.id}\#_index")
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

    def get_current_document_id(session, label='')
      _id = current_user(session).dict2['current_document_id']
      puts "#{label} current_document_id = #{_id}".green
      _id
    end

    def editor_link1(user, active_item='')
      return '' unless user
      doc_id = DocumentActivityManager.new(user).last_document_id
      return '' unless doc_id
      document = DocumentRepository.find doc_id
      return '' unless document
      permission_not_given = Permission.is_not_given?(user, :edit, document)
      return '' if permission_not_given
      if active_item == 'editor'
        return link_to 'Editor', "/editor/document/#{doc_id}", class: 'active_item'
      else
        return  link_to 'Editor', "/editor/document/#{doc_id}", class: ''
      end
    end

    def editor_link(session, active_item='')
      editor_link1(current_user(session), active_item)
    end


    def home_link(session, active_item='')
      active_item == 'home' ? image = '/images/earth_green.png' : image = '/images/home_white.png'
      prefix = get_prefix(session)
      image_link2(prefix: prefix, suffix: 'home', title: 'system home', image: image)
      # image_link2(prefix: :none, suffix: 'home', title: 'system home', image: image)
    end

    def current_user_node_link(session, active_item='')
      prefix = get_prefix(session)
      user = current_user(session)
      return '' if user == nil
      active_item == 'home' ? image = '/images/home_green.png' : image = '/images/person_red.png'
      image_link2(prefix: prefix, suffix: "node/user/#{user.node.name}", title: 'user home', image: image)
    end

    def start_node_link(session, active_item='')
      prefix = get_prefix(session)
      user = current_user(session)
      return '' if user == nil
      active_item == 'home' ? image = '/images/start.png' : image = '/images/start.png'
      image_link2(prefix: prefix, suffix: "node/start", title: 'go to start page', image: image)
    end

    def node_link(node, session)
      prefix = get_prefix(session)
      text_link(prefix: prefix, suffix: "node/#{node.name}", title: node.name)
    end


    def current_node_link(session, active_item='')
      cu = current_user(session)
      return ''  if cu == nil
      nam = Noteshare::Helper::Node::NodeActivityManager.new(user: cu)
      nam.configure
      last_node_name = nam.last_node_name

      prefix = get_prefix(session)

      active_item == 'node' ? image = '/images/node_green.png' : image = '/images/node_white.png'
      image_link2(prefix: prefix, suffix: "node/#{last_node_name}", title: 'current node', image: image)
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
      return ''  if cu == nil or cu.admin == false
      text_link(title: 'Admin', prefix: '' , suffix: 'admin', class: css_class)
    end

    def guide_link(session)
      return text_link(prefix: '', suffix: "aside/#{ENV['USER_GUIDE_DOC_ID']}", title: 'User Guide', class: 'redlink;', style: 'font-weight: bold; margin-bottom:-4px;')
      return text_link(prefix: '', suffix: "aside/#{ENV['USER_GUIDE_DOC_ID']}", title: 'User Guide', class: 'redlink;', style: 'font-weight: bold; margin-bottom:-4px;')
    end

    def documents_link(session, active_item='')
      active_item == 'documents' ? css_class = 'active_item' : css_class = ''
      prefix = get_prefix(session)
      return  text_link(prefix: prefix, suffix: "documents", title: 'Directory', class: css_class)
    end

    def reader_link(session, active_item='')
      return '' if session == nil
      _id = DocumentActivityManager.new(current_user(session)).last_document_id
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