require 'spec_helper'
require_relative '../../../../apps/editor/views/document/create_new_associated_document'

describe Editor::Views::Document::CreateNewAssociatedDocument do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Lotus::View::Template.new('apps/editor/templates/document/create_new_associated_document.html.slim') }
  let(:view)      { Editor::Views::Document::CreateNewAssociatedDocument.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #foo" do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
