require 'spec_helper'
require_relative '../../../../apps/session_manager/controllers/user/login'

describe SessionManager::Controllers::User::Login do
  let(:action) { SessionManager::Controllers::User::Login.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
