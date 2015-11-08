require 'spec_helper'
require_relative '../../../../apps/image_manager/controllers/image/upload'

describe ImageManager::Controllers::Image::Upload do
  let(:action) { ImageManager::Controllers::Image::Upload.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
