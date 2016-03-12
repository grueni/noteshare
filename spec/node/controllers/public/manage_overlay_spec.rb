require 'spec_helper'
require_relative '../../../../apps/node/controllers/public/manage_overlay'

describe Node::Controllers::Public::ManageOverlay do
  let(:action) { Node::Controllers::Public::ManageOverlay.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
