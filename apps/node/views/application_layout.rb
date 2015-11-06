

module Node
  module Views
    class ApplicationLayout
      include Node::Layout
      require_relative '../../../lib/ui/links'
      include UI::Links


    end
  end
end

