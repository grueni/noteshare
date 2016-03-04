require 'spec_helper'
require_relative '../../../../apps/editor/controllers/document/export_latex'

describe Editor::Controllers::Document::ExportLatex do
  let(:action) { Editor::Controllers::Document::ExportLatex.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
