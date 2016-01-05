require 'spec_helper'
require_relative '../../../../apps/editor/views/document/get_file'

describe Editor::Views::Document::GetFile do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Lotus::View::Template.new('apps/editor/templates/document/get_file.html.slim') }
  let(:view)      { Editor::Views::Document::GetFile.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #foo" do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
