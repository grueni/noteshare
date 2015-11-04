require 'spec_helper'
require_relative '../../../../apps/session_manager/views/user/create'

describe SessionManager::Views::User::Create do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Lotus::View::Template.new('apps/session_manager/templates/user/create.html.haml') }
  let(:view)      { SessionManager::Views::User::Create.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #foo" do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
