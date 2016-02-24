module Web::Views::Documents
  class ViewSource
    include Web::View

    def document_presenter
      DocumentPresenter.new(document)
    end

  end
end
