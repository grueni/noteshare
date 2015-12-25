require 'spec_helper'
require_relative '../../../../apps/node/controllers/admin/edit'

describe Node::Controllers::Admin::Edit do
  let(:action) { Node::Controllers::Admin::Edit.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
