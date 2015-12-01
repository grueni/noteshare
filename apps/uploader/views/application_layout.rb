module Uploader
  module Views
    class ApplicationLayout
      include Uploader::Layout
      require_relative '../../../lib/ui/links'
      include UI::Links
    end
  end
end
