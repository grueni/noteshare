require 'spec_helper'
require_relative '../../../../apps/uploader/controllers/image/do_upload'

describe Uploader::Controllers::Image::DoUpload do
  let(:action) { Uploader::Controllers::Image::DoUpload.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
