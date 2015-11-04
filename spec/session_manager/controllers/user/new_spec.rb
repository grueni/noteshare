require 'spec_helper'
require_relative '../../../../apps/session_manager/controllers/user/new'

describe SessionManager::Controllers::User::New do
  let(:action) { SessionManager::Controllers::User::New.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
