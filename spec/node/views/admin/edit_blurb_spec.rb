require 'spec_helper'
require_relative '../../../../apps/node/views/admin/edit_blurb'

describe Node::Views::Admin::EditBlurb do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Lotus::View::Template.new('apps/node/templates/admin/edit_blurb.html.slim') }
  let(:view)      { Node::Views::Admin::EditBlurb.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #foo" do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
