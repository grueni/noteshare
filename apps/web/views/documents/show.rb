module Web::Views::Documents
  class Show
    include Web::View
    include Noteshare::Presenter::Document

    def document_presenter
      DocumentPresenter.new(document)
    end

    def edit_tag

      if document
       link_to 'Editor', "/editor/document/#{document.id}"
      else
        ''
      end

      #  html.tag(:a, 'Edit', href: "/editor/document/#{document.id}")
    end

    def new_tag

      if document
        link_to 'New', "/editor/new/#{document.id}"
      else
        link_to 'New', "/editor/new"
      end

    end

    def documents_tag
      link_to 'Documents', '/documents'
    end

    def left_menu
      [ edit_tag, '&nbsp;&nbsp;', new_tag, '&nbsp;&nbsp;'].map(&:to_s)
     # "Foo"
    end


    def right_menu(session)
      'Right menu (show)'
    end

    def root_document_title
      root =  root_document || self
      if root
        root.title
      else
        ''
      end
    end

  end
end
