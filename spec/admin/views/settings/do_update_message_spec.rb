require 'spec_helper'
require_relative '../../../../apps/admin/views/settings/do_update_message'

describe Admin::Views::Settings::DoUpdateMessage do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Lotus::View::Template.new('apps/admin/templates/settings/do_update_message.html.slim') }
  let(:view)      { Admin::Views::Settings::DoUpdateMessage.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #foo" do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
