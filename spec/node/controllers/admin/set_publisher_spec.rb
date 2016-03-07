require 'spec_helper'
require_relative '../../../../apps/node/controllers/admin/set_publisher'

describe Node::Controllers::Admin::SetPublisher do
  let(:action) { Node::Controllers::Admin::SetPublisher.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
