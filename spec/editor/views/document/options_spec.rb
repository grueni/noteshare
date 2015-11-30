require 'spec_helper'
require_relative '../../../../apps/editor/views/document/options'

describe Editor::Views::Document::Options do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Lotus::View::Template.new('apps/editor/templates/document/options.html.slim') }
  let(:view)      { Editor::Views::Document::Options.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #foo" do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
