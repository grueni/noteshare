require 'spec_helper'
require_relative '../../../../apps/session_manager/controllers/user/create'

describe SessionManager::Controllers::User::Create do
  let(:action) { SessionManager::Controllers::User::Create.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
