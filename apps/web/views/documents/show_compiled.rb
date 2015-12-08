

module Web::Views::Documents
  class ShowCompiled
    include Web::View
    include UI::Links

    def tocc
      raw toc
    end

  end
end
