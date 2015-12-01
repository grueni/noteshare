require 'spec_helper'
require_relative '../../../../apps/editor/views/documents/create'

describe Editor::Views::Documents::Create do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Lotus::View::Template.new('apps/editor/templates/documents/create.html.slim') }
  let(:view)      { Editor::Views::Documents::Create.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #foo" do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
