require 'spec_helper'
require_relative '../../../../apps/web/controllers/home/about'

describe Web::Controllers::Home::About do
  let(:action) { Web::Controllers::Home::About.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
