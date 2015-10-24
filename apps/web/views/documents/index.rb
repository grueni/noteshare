module Web::Views::Documents
  class Index
    include Web::View


    def left_menu
      html.tag(:a, 'New', href: '/editor/new')
    end
    

  end
end
