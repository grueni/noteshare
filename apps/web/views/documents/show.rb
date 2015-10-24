module Web::Views::Documents
  class Show
    include Web::View

    def edit_tag
      html.tag(:a, 'Edit', href: "/editor/document/#{document.id}")
    end

    def new_tag
      html.tag(:a, 'New', href: '/editor/new')
    end

    def documents_tag
      html.tag(:a, 'Documents', href: '/documents')
    end

    def left_menu
      [edit_tag, new_tag, documents_tag].map(&:to_s)
    end

  end
end
