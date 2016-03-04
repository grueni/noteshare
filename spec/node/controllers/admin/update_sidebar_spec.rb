require 'spec_helper'
require_relative '../../../../apps/node/controllers/admin/update_sidebar'

describe Node::Controllers::Admin::UpdateSidebar do
  let(:action) { Node::Controllers::Admin::UpdateSidebar.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
