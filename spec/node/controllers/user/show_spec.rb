require 'spec_helper'
require_relative '../../../../apps/node/controllers/user/show'

describe Node::Controllers::User::Show do
  let(:action) { Node::Controllers::User::Show.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
