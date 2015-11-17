require 'spec_helper'
require_relative '../../../../apps/node/views/admin/list'

describe Node::Views::Admin::List do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Lotus::View::Template.new('apps/node/templates/admin/list.html.slim') }
  let(:view)      { Node::Views::Admin::List.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #foo" do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
