require 'spec_helper'
require_relative '../../../../apps/node/controllers/user/manage'

describe Node::Controllers::User::Manage do
  let(:action) { Node::Controllers::User::Manage.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
