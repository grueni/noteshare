require 'spec_helper'
require_relative '../../../../apps/editor/views/document/add_pdf'

describe Editor::Views::Document::AddPdf do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Lotus::View::Template.new('apps/editor/templates/document/add_pdf.html.slim') }
  let(:view)      { Editor::Views::Document::AddPdf.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #foo" do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
