require 'spec_helper'
require_relative '../../../../apps/admin/controllers/documents/delete'

describe Admin::Controllers::Documents::Delete do
  let(:action) { Admin::Controllers::Documents::Delete.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
