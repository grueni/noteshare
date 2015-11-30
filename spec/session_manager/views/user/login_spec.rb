require 'spec_helper'
require_relative '../../../../apps/session_manager/views/user/login'

describe SessionManager::Views::User::Login do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Lotus::View::Template.new('apps/session_manager/templates/user/login.html.slim') }
  let(:view)      { SessionManager::Views::User::Login.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #foo" do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
