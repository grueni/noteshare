require 'spec_helper'
require_relative '../../../apps/editor/controllers/documents/new'

describe Editor::Views::Documents::New do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Lotus::View::Template.new('apps/editor/templates/documents/new.html.slim') }
  let(:view)      { Editor::Views::Documents::New.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #foo" do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
