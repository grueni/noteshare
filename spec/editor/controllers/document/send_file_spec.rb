require 'spec_helper'
require_relative '../../../../apps/editor/controllers/document/send_file'

describe Editor::Controllers::Document::SendFile do
  let(:action) { Editor::Controllers::Document::SendFile.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
