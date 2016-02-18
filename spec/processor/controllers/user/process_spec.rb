require 'spec_helper'
require_relative '../../../../apps/processor/controllers/user/process'

describe Processor::Controllers::User::Process do
  let(:action) { Processor::Controllers::User::Process.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
