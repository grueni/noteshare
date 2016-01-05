require 'spec_helper'
require_relative '../../../../apps/editor/views/document/send_file'

describe Editor::Views::Document::SendFile do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Lotus::View::Template.new('apps/editor/templates/document/send_file.html.slim') }
  let(:view)      { Editor::Views::Document::SendFile.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #foo" do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
