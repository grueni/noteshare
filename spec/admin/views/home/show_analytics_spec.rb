require 'spec_helper'
require_relative '../../../../apps/admin/views/home/show_analytics'

describe Admin::Views::Home::ShowAnalytics do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Lotus::View::Template.new('apps/admin/templates/home/show_analytics.html.slim') }
  let(:view)      { Admin::Views::Home::ShowAnalytics.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #foo" do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
