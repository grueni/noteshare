require 'spec_helper'
require_relative '../../../../apps/editor/views/document/manage_publications'

describe Editor::Views::Document::ManagePublications do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Lotus::View::Template.new('apps/editor/templates/document/manage_publications.html.slim') }
  let(:view)      { Editor::Views::Document::ManagePublications.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #foo" do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
