require 'spec_helper'
require_relative '../../../../apps/node/controllers/user/remove'

describe Node::Controllers::User::Remove do
  let(:action) { Node::Controllers::User::Remove.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
