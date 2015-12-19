require 'spec_helper'
require_relative '../../../../apps/web/views/documents/titlepage'

describe Web::Views::Documents::Titlepage do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Lotus::View::Template.new('apps/web/templates/documents/titlepage.html.slim') }
  let(:view)      { Web::Views::Documents::Titlepage.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #foo" do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
