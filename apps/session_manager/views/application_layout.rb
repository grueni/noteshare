require_relative '../../../lib/ui/links'

module SessionManager
  module Views
    class ApplicationLayout
      include SessionManager::Layout
      include UI::Links
    end
  end
end
