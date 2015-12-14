require 'spec_helper'
require_relative '../../../../apps/editor/controllers/document/update_toc'

describe Editor::Controllers::Document::UpdateToc do
  let(:action) { Editor::Controllers::Document::UpdateToc.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
