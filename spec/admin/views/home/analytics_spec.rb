require 'spec_helper'
require_relative '../../../../apps/admin/views/home/display_analytics'

describe Admin::Views::Home::Analytics do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Lotus::View::Template.new('apps/admin/templates/home/analytics.html.slim') }
  let(:view)      { Admin::Views::Home::Analytics.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #foo" do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
