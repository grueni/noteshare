require 'spec_helper'
require_relative '../../../../apps/session_manager/controllers/settings/edit'

describe SessionManager::Controllers::Settings::Edit do
  let(:action) { SessionManager::Controllers::Settings::Edit.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
