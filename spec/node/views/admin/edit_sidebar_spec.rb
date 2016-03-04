require 'spec_helper'
require_relative '../../../../apps/node/views/admin/edit_sidebar'

describe Node::Views::Admin::EditSidebar do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Lotus::View::Template.new('apps/node/templates/admin/edit_sidebar.html.slim') }
  let(:view)      { Node::Views::Admin::EditSidebar.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #foo" do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
