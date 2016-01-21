require 'spec_helper'
require_relative '../../../../apps/admin/controllers/course/find'

describe Admin::Controllers::Course::Find do
  let(:action) { Admin::Controllers::Course::Find.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
