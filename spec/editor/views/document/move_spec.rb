require 'spec_helper'
require_relative '../../../../apps/editor/views/document/move'

describe Editor::Views::Document::Move do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Lotus::View::Template.new('apps/editor/templates/document/move.html.slim') }
  let(:view)      { Editor::Views::Document::Move.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #foo" do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
