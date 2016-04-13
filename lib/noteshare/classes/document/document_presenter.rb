module Noteshare
  module Presenter
    module Docuemnt
    end

    class DocumentPresenter

      def initialize(document)
        @document = document
      end

      def rendered_content
        if @document.rendered_content and @document.rendered_content != ''
          return @document.rendered_content
        else
          return "<p style='margin:3em;font-size:24pt;'>This block of the document is blank.  Please edit it or go to the next block</p>"
        end

      end

    end
  end
end