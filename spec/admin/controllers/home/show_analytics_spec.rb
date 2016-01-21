require 'spec_helper'
require_relative '../../../../apps/admin/controllers/home/show_analytics'

describe Admin::Controllers::Home::ShowAnalytics do
  let(:action) { Admin::Controllers::Home::ShowAnalytics.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
