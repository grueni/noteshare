require 'spec_helper'
require_relative '../../../../apps/web/views/documents/aside'

describe Web::Views::Documents::Aside do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Lotus::View::Template.new('apps/web/templates/documents/aside.html.slim') }
  let(:view)      { Web::Views::Documents::Aside.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #foo" do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
