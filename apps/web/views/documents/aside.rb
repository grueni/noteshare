module Web::Views::Documents
  class Aside
    include Web::View
    include Noteshare::Presenter::Document

    def root_document_title
      root =  root_document || self
      if root
        root.title
      else
        ''
      end
    end

    def document_presenter
      DocumentPresenter.new(document)
    end

    def aside_presenter
      DocumentPresenter.new(aside)
    end

  end
end
