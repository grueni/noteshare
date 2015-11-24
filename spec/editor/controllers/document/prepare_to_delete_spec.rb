require 'spec_helper'
require_relative '../../../../apps/editor/controllers/document/prepare_to_delete'

describe Editor::Controllers::Document::PrepareToDelete do
  let(:action) { Editor::Controllers::Document::PrepareToDelete.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
