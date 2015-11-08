


module Web
  module Views
    class ApplicationLayout
      include Web::Layout
      require_relative '../../../lib/ui/links'
      include UI::Links
      include UI::Forms

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

    end
  end
end
