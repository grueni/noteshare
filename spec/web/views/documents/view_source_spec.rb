require 'spec_helper'
require_relative '../../../../apps/web/views/documents/view_source'

describe Web::Views::Documents::ViewSource do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Lotus::View::Template.new('apps/web/templates/documents/view_source.html.slim') }
  let(:view)      { Web::Views::Documents::ViewSource.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #foo" do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
