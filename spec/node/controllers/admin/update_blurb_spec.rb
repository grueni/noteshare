require 'spec_helper'
require_relative '../../../../apps/node/controllers/admin/update_blurb'

describe Node::Controllers::Admin::UpdateBlurb do
  let(:action) { Node::Controllers::Admin::UpdateBlurb.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
