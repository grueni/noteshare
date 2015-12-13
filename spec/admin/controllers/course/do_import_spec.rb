require 'spec_helper'
require_relative '../../../../apps/admin/controllers/course/do_import'

describe Admin::Controllers::Course::DoImport do
  let(:action) { Admin::Controllers::Course::DoImport.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
