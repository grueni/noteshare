require 'spec_helper'
require_relative '../../../../apps/web/controllers/documents/new'

describe Web::Controllers::Documents::New do
  let(:action) { Web::Controllers::Documents::New.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
