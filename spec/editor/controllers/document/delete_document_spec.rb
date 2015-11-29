require 'spec_helper'
require_relative '../../../../apps/editor/controllers/document/delete_document'

describe Editor::Controllers::Document::DeleteDocument do
  let(:action) { Editor::Controllers::Document::DeleteDocument.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
