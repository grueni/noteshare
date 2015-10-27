module Web
  module Views
    class ApplicationLayout
      include Web::Layout

      def mathjax_script(doc)
        if doc and doc.render_options['format']
           "http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"
        else
          ''
        end
      end

      def left_menu
        ''
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
