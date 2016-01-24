require 'spec_helper'
require_relative '../../../../apps/node/views/user/manage'

describe Node::Views::User::Manage do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Lotus::View::Template.new('apps/node/templates/user/manage.html.slim') }
  let(:view)      { Node::Views::User::Manage.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #foo" do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
