require 'spec_helper'
require_relative '../../../../apps/node/controllers/admin/create'

describe Node::Controllers::Admin::Create do
  let(:action) { Node::Controllers::Admin::Create.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
