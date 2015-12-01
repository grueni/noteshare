require 'spec_helper'
require_relative '../../../../apps/uploader/controllers/file/upload'

describe Uploader::Controllers::File::Upload do
  let(:action) { Uploader::Controllers::File::Upload.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
