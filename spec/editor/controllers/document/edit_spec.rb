require 'spec_helper'
require_relative '../../../../apps/editor/controllers/document/edit'

describe Editor::Controllers::Document::Edit do
  let(:action) { Editor::Controllers::Document::Edit.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
