module Web::Views::Documents
  class Index
    include Web::View
    require_relative '../../../../lib/ui/links'
    include UI::Forms


    def left_menu
      html.tag(:a, 'New', href: '/editor/new')
    end

     def right_menu(session)
       out = "<ul id='navlist'>\n"
       out << "<li> <a href='/documents/'>Documents</a> </li>\n"
       out << "</ul>\n"
       # html.div(out)
     end

  end
end
