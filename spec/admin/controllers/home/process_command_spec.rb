require 'spec_helper'
require_relative '../../../../apps/admin/controllers/home/process_command'

describe Admin::Controllers::Home::ProcessCommand do
  let(:action) { Admin::Controllers::Home::ProcessCommand.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
