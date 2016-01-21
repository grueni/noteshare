require 'spec_helper'
require_relative '../../../../apps/admin/views/course/find'

describe Admin::Views::Course::Find do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Lotus::View::Template.new('apps/admin/templates/course/find.html.slim') }
  let(:view)      { Admin::Views::Course::Find.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #foo" do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
