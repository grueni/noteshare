require 'spec_helper'
require_relative '../../../../apps/admin/controllers/course/import'

describe Admin::Controllers::Course::Import do
  let(:action) { Admin::Controllers::Course::Import.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
