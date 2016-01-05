require 'spec_helper'
require_relative '../../../../apps/editor/controllers/document/get_file'

describe Editor::Controllers::Document::GetFile do
  let(:action) { Editor::Controllers::Document::GetFile.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
