require 'spec_helper'
require_relative '../../../../apps/admin/controllers/publications/manage'

describe Admin::Controllers::Publications::Manage do
  let(:action) { Admin::Controllers::Publications::Manage.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
