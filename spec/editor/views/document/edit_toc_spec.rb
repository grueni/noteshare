require 'spec_helper'
require_relative '../../../../apps/editor/views/document/edit_toc'

describe Editor::Views::Document::EditToc do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Lotus::View::Template.new('apps/editor/templates/document/edit_toc.html.slim') }
  let(:view)      { Editor::Views::Document::EditToc.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #foo" do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
