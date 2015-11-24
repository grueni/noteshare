require 'spec_helper'
require_relative '../../../../apps/node/controllers/public/show'

describe Node::Controllers::Public::Show do
  let(:action) { Node::Controllers::Public::Show.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
