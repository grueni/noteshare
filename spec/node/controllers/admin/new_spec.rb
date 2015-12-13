require 'spec_helper'
require_relative '../../../../apps/node/controllers/admin/new'

describe Node::Controllers::Admin::New do
  let(:action) { Node::Controllers::Admin::New.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
