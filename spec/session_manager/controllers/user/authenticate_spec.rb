require 'spec_helper'
require_relative '../../../../apps/session_manager/controllers/user/authenticate'

describe SessionManager::Controllers::User::Authenticate do
  let(:action) { SessionManager::Controllers::User::Authenticate.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
