require 'spec_helper'
require_relative '../../../../apps/web/controllers/documents/set_search_type'

describe Web::Controllers::Documents::SetSearchType do
  let(:action) { Web::Controllers::Documents::SetSearchType.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
