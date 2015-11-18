require 'spec_helper'
require_relative '../../../../apps/editor/views/document/new_section'

describe Editor::Views::Document::NewSection do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Lotus::View::Template.new('apps/editor/templates/document/new_section.html.slim') }
  let(:view)      { Editor::Views::Document::NewSection.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #foo" do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
