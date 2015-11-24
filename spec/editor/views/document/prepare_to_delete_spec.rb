require 'spec_helper'
require_relative '../../../../apps/editor/views/document/prepare_to_delete'

describe Editor::Views::Document::PrepareToDelete do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Lotus::View::Template.new('apps/editor/templates/document/prepare_to_delete.html.slim') }
  let(:view)      { Editor::Views::Document::PrepareToDelete.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #foo" do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
