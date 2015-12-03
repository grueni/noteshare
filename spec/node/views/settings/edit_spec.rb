require 'spec_helper'
require_relative '../../../../apps/node/views/settings/edit'

describe Node::Views::Settings::Edit do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Lotus::View::Template.new('apps/node/templates/settings/edit.html.slim') }
  let(:view)      { Node::Views::Settings::Edit.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #foo" do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
