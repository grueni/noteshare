module UI
  module Links

    def home_link
      link_to 'Home', '/'
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

    def admin_link
      link_to 'Admin', '/admin'
    end

  end
end