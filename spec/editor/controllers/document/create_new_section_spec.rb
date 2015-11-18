require 'spec_helper'
require_relative '../../../../apps/editor/controllers/document/create_new_section'

describe Editor::Controllers::Document::CreateNewSection do
  let(:action) { Editor::Controllers::Document::CreateNewSection.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
