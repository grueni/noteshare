require 'spec_helper'
require_relative '../../../../apps/admin/views/publications/manage'

describe Admin::Views::Publications::Manage do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Lotus::View::Template.new('apps/admin/templates/publications/manage.html.slim') }
  let(:view)      { Admin::Views::Publications::Manage.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #foo" do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
