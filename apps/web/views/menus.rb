# require 'lotus/apps/web'


module Web
  module Views
    module Menus

     def left_menu
       div do
         ul(id: 'Christmas') do
           li 'Elves'
           li 'Sled'
         end
       end
     end

    end
  end
end



=begin
== home_link
        | &nbsp;&nbsp;&nbsp;
        == current_user_node_link(session)
        | &nbsp; &nbsp; &nbsp; &nbsp;
        == basic_search_form
=end
