require 'spec_helper'
require_relative '../../../../apps/image_manager/controllers/new_image/new'

describe ImageManager::Controllers::NewImage::Accept do
  let(:action) { ImageManager::Controllers::NewImage::Accept.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
