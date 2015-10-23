module Web::Views::Documents
  class Index
    include Web::View

    def left_menu_item
      "<a href='http::/localhost:2300/editor/new'>New</a>"
    end

  end
end
