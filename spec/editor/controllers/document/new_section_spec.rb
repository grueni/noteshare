require 'spec_helper'
require_relative '../../../../apps/editor/controllers/document/new_section'

describe Editor::Controllers::Document::NewSection do
  let(:action) { Editor::Controllers::Document::NewSection.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
