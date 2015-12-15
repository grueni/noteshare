

module Web
  module Views
    class ApplicationLayout
      include Web::Layout
      # include Web::Assets::Helpers
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

    end
  end
end
