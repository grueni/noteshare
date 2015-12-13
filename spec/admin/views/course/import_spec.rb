require 'spec_helper'
require_relative '../../../../apps/admin/views/course/import'

describe Admin::Views::Course::Import do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Lotus::View::Template.new('apps/admin/templates/course/import.html.slim') }
  let(:view)      { Admin::Views::Course::Import.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #foo" do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
