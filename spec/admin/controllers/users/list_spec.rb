require 'spec_helper'
require_relative '../../../../apps/admin/controllers/users/list'

describe Admin::Controllers::Users::List do
  let(:action) { Admin::Controllers::Users::List.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
