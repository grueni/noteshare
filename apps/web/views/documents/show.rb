module Web::Views::Documents
  class Show
    include Web::View

    def left_menu
      html.div { edit_tag  }
    end

    def edit_tag
      html.tag(:a, 'Edit', href: "/editor/document/#{document.id}")
    end

    def new_tag
      html.tag(:a, 'New', href: '/editor/new')
    end

    def documents_tag
      html.tag(:a, 'Documents', href: '/documents')
    end


  end
end
