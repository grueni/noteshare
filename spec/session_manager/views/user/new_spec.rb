require 'spec_helper'
require_relative '../../../../apps/session_manager/views/user/new'

describe SessionManager::Views::User::New do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Lotus::View::Template.new('apps/session_manager/templates/user/new.html.haml') }
  let(:view)      { SessionManager::Views::User::New.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #foo" do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
