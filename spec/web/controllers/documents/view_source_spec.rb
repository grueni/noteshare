require 'spec_helper'
require_relative '../../../../apps/web/controllers/documents/view_source'

describe Web::Controllers::Documents::ViewSource do
  let(:action) { Web::Controllers::Documents::ViewSource.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
