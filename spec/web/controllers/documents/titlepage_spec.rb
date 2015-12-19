require 'spec_helper'
require_relative '../../../../apps/web/controllers/documents/titlepage'

describe Web::Controllers::Documents::Titlepage do
  let(:action) { Web::Controllers::Documents::Titlepage.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
