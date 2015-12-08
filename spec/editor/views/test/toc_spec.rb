require 'spec_helper'
require_relative '../../../../apps/editor/views/test/toc'

describe Editor::Views::Test::Toc do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Lotus::View::Template.new('apps/editor/templates/test/toc.html.slim') }
  let(:view)      { Editor::Views::Test::Toc.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #foo" do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
