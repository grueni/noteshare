module UI
  module Links
    require_relative '../../lib/user_authentication'
    include SessionTools

    def home_link
      link_to 'NS', '/'
    end

    def current_user_node_link(session)
      user = current_user(session)
      link_to "#{user.screen_name.capitalize}", "/node/user/#{user.node_id}"
    end

    def current_user_node_link2(session)
      puts "HOHOHO!".magenta
      # puts session[:user_id]
      puts session.inspect.to_s.magenta
      'foobar'
    end


    def document_link(document)
      link_to document.title, "/document/#{document.id}"
    end

    def documents_link
      link_to 'Documents', '/documents'
    end

    def reader_link(doc)
      #'READER_LINK'
      if doc
        link_to 'Reader', "/document/#{doc.id}"
      else
        ''
      end
    end

    def signin_link
      link_to 'Sign in', '/session_manager/login'
    end

    def signup_link
      link_to 'Sign up', '/session_manager/new_user'
    end

    def admin_link
      link_to 'Admin', '/admin'
    end

    def settings_link(document)
      link_to "Settings", "/editor/document/options/#{document.id}"
    end

    def export_link(document)
      link_to 'Export', "/editor/export/#{document.id}"
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