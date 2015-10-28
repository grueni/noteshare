module Editor
  module Views
    class ApplicationLayout
      include Editor::Layout
      require_relative '../../../lib/ui/links'
      include UI::Links

      def mathjax_script(doc)
        if doc and doc.render_options['format']
          "http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"
        else
          ''
        end
      end

      def options_link(document)
        link_to 'Options', "/editor/document/options/#{document.id}"
      end

    end
  end
end
