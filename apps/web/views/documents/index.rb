module Web::Views::Documents
  class Index
    include Web::View
    require_relative '../../../../lib/ui/links'
    include UI::Forms


    def left_menu
      html.tag(:a, 'New', href: '/editor/new')
    end
    

  end
end
