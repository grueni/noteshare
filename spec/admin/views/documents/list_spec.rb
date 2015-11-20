require 'spec_helper'
require_relative '../../../../apps/admin/views/documents/list'

describe Admin::Views::Documents::List do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Lotus::View::Template.new('apps/admin/templates/documents/list.html.slim') }
  let(:view)      { Admin::Views::Documents::List.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #foo" do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
