require 'spec_helper'
require_relative '../../../../apps/node/controllers/admin/list'

describe Node::Controllers::Admin::List do
  let(:action) { Node::Controllers::Admin::List.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
