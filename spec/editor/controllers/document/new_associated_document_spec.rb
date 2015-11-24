require 'spec_helper'
require_relative '../../../../apps/editor/controllers/document/new_associated_document'

describe Editor::Controllers::Document::NewAssociatedDocument do
  let(:action) { Editor::Controllers::Document::NewAssociatedDocument.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
