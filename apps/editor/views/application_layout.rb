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

      def reader_link
        link_to 'Reader', "/document/#{document.id}"
      end

      def home_link
        link_to 'Home', '/'
      end

      def documents_link
        link_to 'Documents', '/documents'
      end

    end
  end
end
