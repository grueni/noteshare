require 'spec_helper'
require_relative '../../../../apps/admin/controllers/settings/do_update_message'

describe Admin::Controllers::Settings::DoUpdateMessage do
  let(:action) { Admin::Controllers::Settings::DoUpdateMessage.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
