module Admin
  module Views
    class ApplicationLayout
      include Admin::Layout

      def home_link
        link_to 'Home', '/'
      end

    end
  end
end
