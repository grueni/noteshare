require 'spec_helper'
require_relative '../../../../apps/editor/controllers/document/json_update'

describe Editor::Controllers::Document::JsonUpdate do
  let(:action) { Editor::Controllers::Document::JsonUpdate.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
