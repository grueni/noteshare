module Web::Views::Documents
  class Index
    include Web::View

    def edit_tag

    end

    def new_tag
      html.tag(:a, 'New', href: '/editor/new')
    end

    def documents_tag

    end

  end
end
