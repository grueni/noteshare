module Viewer
  module Views
    class ApplicationLayout
      include Viewer::Layout
      require_relative '../../../lib/ui/links'
      include UI::Links
    end
  end
end
