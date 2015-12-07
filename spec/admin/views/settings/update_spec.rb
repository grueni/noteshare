require 'spec_helper'
require_relative '../../../../apps/admin/views/settings/update'

describe Admin::Views::Settings::Update do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Lotus::View::Template.new('apps/admin/templates/settings/update.html.slim') }
  let(:view)      { Admin::Views::Settings::Update.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #foo" do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
