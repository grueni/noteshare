require 'spec_helper'
require_relative '../../../../apps/node/controllers/admin/update'

describe Node::Controllers::Admin::Update do
  let(:action) { Node::Controllers::Admin::Update.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
