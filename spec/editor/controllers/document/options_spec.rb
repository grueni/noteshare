require 'spec_helper'
require_relative '../../../../apps/editor/controllers/document/options'

describe Editor::Controllers::Document::Options do
  let(:action) { Editor::Controllers::Document::Options.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
