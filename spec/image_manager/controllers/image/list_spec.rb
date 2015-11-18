require 'spec_helper'
require_relative '../../../../apps/image_manager/controllers/image/list'

describe ImageManager::Controllers::Image::List do
  let(:action) { ImageManager::Controllers::Image::List.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
