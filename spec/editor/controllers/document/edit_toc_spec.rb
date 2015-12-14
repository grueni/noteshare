require 'spec_helper'
require_relative '../../../../apps/editor/controllers/document/edit_toc'

describe Editor::Controllers::Document::EditToc do
  let(:action) { Editor::Controllers::Document::EditToc.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
