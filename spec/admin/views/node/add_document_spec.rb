require 'spec_helper'
require_relative '../../../../apps/admin/views/node/add_document'

describe Admin::Views::Node::AddDocument do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Lotus::View::Template.new('apps/admin/templates/node/add_document.html.slim') }
  let(:view)      { Admin::Views::Node::AddDocument.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #foo" do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
