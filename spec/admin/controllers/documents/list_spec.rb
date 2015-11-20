require 'spec_helper'
require_relative '../../../../apps/admin/controllers/documents/list'

describe Admin::Controllers::Documents::List do
  let(:action) { Admin::Controllers::Documents::List.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
