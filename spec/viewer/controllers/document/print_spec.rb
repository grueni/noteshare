require 'spec_helper'
require_relative '../../../../apps/viewer/controllers/document/print'

describe Viewer::Controllers::Document::Print do
  let(:action) { Viewer::Controllers::Document::Print.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
