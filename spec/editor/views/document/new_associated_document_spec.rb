require 'spec_helper'
require_relative '../../../../apps/editor/views/document/new_associated_document'

describe Editor::Views::Document::NewAssociatedDocument do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Lotus::View::Template.new('apps/editor/templates/document/new_associated_document.html.slim') }
  let(:view)      { Editor::Views::Document::NewAssociatedDocument.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #foo" do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
