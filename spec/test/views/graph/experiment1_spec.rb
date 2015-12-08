require 'spec_helper'
require_relative '../../../../apps/test/views/graph/experiment1'

describe Test::Views::Graph::Experiment1 do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Lotus::View::Template.new('apps/test/templates/graph/experiment1.html.slim') }
  let(:view)      { Test::Views::Graph::Experiment1.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #foo" do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
