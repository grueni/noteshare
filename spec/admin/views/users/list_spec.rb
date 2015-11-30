require 'spec_helper'
require_relative '../../../../apps/admin/views/users/list'

describe Admin::Views::Users::List do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Lotus::View::Template.new('apps/admin/templates/users/list.html.slim') }
  let(:view)      { Admin::Views::Users::List.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #foo" do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
