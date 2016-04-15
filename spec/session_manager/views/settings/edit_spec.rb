require 'spec_helper'
require_relative '../../../../apps/session_manager/views/settings/edit'

describe SessionManager::Views::Settings::Edit do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Lotus::View::Template.new('apps/session_manager/templates/settings/edit.html.slim') }
  let(:view)      { SessionManager::Views::Settings::Edit.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #foo" do
    view.foo.must_equal exposures.fetch(:foo)
  end
end

