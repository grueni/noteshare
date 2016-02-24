

module Node
  module Views
    class ApplicationLayout
      include Node::Layout
      require_relative '../../../lib/ui/links'
      include UI::Links

      def document_link(document)
        link_to document.title, "/document/#{document.id}"
      end

      def user_settings_link
        image_link '/images/gears.png', '/session_manager/settings', 'user settings'
      end

    end
  end
end

