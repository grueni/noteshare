require 'spec_helper'
require_relative '../../../../apps/node/views/public/list'

describe Node::Views::Public::List do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Lotus::View::Template.new('apps/node/templates/public/list.html.slim') }
  let(:view)      { Node::Views::Public::List.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #foo" do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
