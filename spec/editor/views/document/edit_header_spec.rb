require 'spec_helper'
require_relative '../../../../apps/editor/views/document/edit_header'

describe Editor::Views::Document::EditHeader do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Lotus::View::Template.new('apps/editor/templates/document/edit_header.html.slim') }
  let(:view)      { Editor::Views::Document::EditHeader.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #foo" do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
