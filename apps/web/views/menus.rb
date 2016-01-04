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

