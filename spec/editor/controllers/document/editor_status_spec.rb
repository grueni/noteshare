require 'spec_helper'
require_relative '../../../../apps/editor/controllers/document/editor_status'

describe Editor::Controllers::Document::EditorStatus do
  let(:action) { Editor::Controllers::Document::EditorStatus.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
