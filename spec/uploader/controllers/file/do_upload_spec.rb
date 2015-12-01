require 'spec_helper'
require_relative '../../../../apps/uploader/controllers/file/do_upload'

describe Uploader::Controllers::File::DoUpload do
  let(:action) { Uploader::Controllers::File::DoUpload.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
