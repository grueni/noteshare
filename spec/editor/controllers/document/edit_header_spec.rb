require 'spec_helper'
require_relative '../../../../apps/editor/controllers/document/edit_header'

describe Editor::Controllers::Document::EditHeader do
  let(:action) { Editor::Controllers::Document::EditHeader.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
