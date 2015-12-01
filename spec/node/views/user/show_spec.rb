require 'spec_helper'
require_relative '../../../../apps/node/views/user/show'

describe Node::Views::User::Show do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Lotus::View::Template.new('apps/node/templates/user/show.html.slim') }
  let(:view)      { Node::Views::User::Show.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #foo" do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
