require 'spec_helper'
require_relative '../../../../apps/node/controllers/public/list'

describe Node::Controllers::Public::List do
  let(:action) { Node::Controllers::Public::List.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
