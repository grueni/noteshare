require 'spec_helper'
require_relative '../../../../apps/editor/controllers/document/create_new_associated_document'

describe Editor::Controllers::Document::CreateNewAssociatedDocument do
  let(:action) { Editor::Controllers::Document::CreateNewAssociatedDocument.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
