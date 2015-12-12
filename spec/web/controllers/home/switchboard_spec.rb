require 'spec_helper'
require_relative '../../../../apps/web/controllers/home/switchboard'

describe Web::Controllers::Home::Switchboard do
  let(:action) { Web::Controllers::Home::Switchboard.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
