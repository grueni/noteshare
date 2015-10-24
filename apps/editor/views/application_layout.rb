module Editor
  module Views
    class ApplicationLayout
      include Editor::Layout

      def mathjax_script(doc)
        if doc and doc.render_options['format']
          "http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"
        else
          ''
        end
      end

    end
  end
end
