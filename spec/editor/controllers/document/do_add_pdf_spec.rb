require 'spec_helper'
require_relative '../../../../apps/editor/controllers/document/do_add_pdf'

describe Editor::Controllers::Document::DoAddPdf do
  let(:action) { Editor::Controllers::Document::DoAddPdf.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
