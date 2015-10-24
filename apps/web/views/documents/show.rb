module Web::Views::Documents
  class Show
    include Web::View

    def edit_tag
      link_to 'Edit', "/editor/document/#{document.id}"
      #  html.tag(:a, 'Edit', href: "/editor/document/#{document.id}")
    end

    def new_tag
      link_to 'New', '/editor/new'
    end

    def documents_tag
      link_to 'Documents', '/documents'
    end

    def left_menu
      [edit_tag, '&nbsp;', new_tag, '&nbsp;', documents_tag].map(&:to_s)
    end

  end
end
