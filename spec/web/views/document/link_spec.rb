require 'spec_helper'
require_relative '../../../../apps/web/views/document/link'

describe Web::Views::Document::Link do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Lotus::View::Template.new('apps/web/templates/document/link.html.slim') }
  let(:view)      { Web::Views::Document::Link.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #foo" do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
