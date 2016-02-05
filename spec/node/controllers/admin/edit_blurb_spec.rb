require 'spec_helper'
require_relative '../../../../apps/node/controllers/admin/edit_blurb'

describe Node::Controllers::Admin::EditBlurb do
  let(:action) { Node::Controllers::Admin::EditBlurb.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
