require 'spec_helper'
require_relative '../../../../apps/node/controllers/admin/edit_sidebar'

describe Node::Controllers::Admin::EditSidebar do
  let(:action) { Node::Controllers::Admin::EditSidebar.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
