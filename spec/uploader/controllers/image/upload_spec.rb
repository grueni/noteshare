require 'spec_helper'
require_relative '../../../../apps/uploader/controllers/image/upload'

describe Uploader::Controllers::Image::Upload do
  let(:action) { Uploader::Controllers::Image::Upload.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
