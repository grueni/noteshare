require 'spec_helper'
require_relative '../../../../apps/session_manager/views/user/authenticate'

describe SessionManager::Views::User::Authenticate do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Lotus::View::Template.new('apps/session_manager/templates/user/authenticate.html.haml') }
  let(:view)      { SessionManager::Views::User::Authenticate.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #foo" do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
