module ImageManager
  module Views
    class ApplicationLayout
      include ImageManager::Layout
      require_relative '../../../lib/ui/links'
      include UI::Links

    end
  end
end
