require 'spec_helper'
require_relative '../../../../apps/node/views/public/show'

describe Node::Views::Public::Show do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Lotus::View::Template.new('apps/node/templates/public/show.html.slim') }
  let(:view)      { Node::Views::Public::Show.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #foo" do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
