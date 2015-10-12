require 'spec_helper'
require_relative '../../../../apps/web/views/documents/index'

describe Web::Views::Documents::Index do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Lotus::View::Template.new('apps/web/templates/documents/index.html.haml') }
  let(:view)      { Web::Views::Documents::Index.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #foo" do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
