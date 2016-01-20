require 'spec_helper'
require_relative '../../../../apps/viewer/views/document/print'

describe Viewer::Views::Document::Print do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Lotus::View::Template.new('apps/viewer/templates/document/print.html.slim') }
  let(:view)      { Viewer::Views::Document::Print.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #foo" do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
