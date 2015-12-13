require 'spec_helper'
require_relative '../../../../apps/node/views/admin/new'

describe Node::Views::Admin::New do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Lotus::View::Template.new('apps/node/templates/admin/new.html.slim') }
  let(:view)      { Node::Views::Admin::New.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #foo" do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
