module Web::Views::Documents
  class Aside
    include Web::View

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
