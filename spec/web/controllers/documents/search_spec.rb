require 'spec_helper'
require_relative '../../../../apps/web/controllers/documents/search'

describe Web::Controllers::Documents::Search do
  let(:action) { Web::Controllers::Documents::Search.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
