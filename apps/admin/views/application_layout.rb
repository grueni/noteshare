module Admin
  module Views
    class ApplicationLayout
      include Admin::Layout
      require_relative '../../../lib/ui/links'
      include UI::Links

    end
  end
end
