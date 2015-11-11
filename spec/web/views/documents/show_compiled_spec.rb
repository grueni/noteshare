require 'spec_helper'
require_relative '../../../../apps/web/views/documents/show_compiled'

describe Web::Views::Documents::ShowCompiled do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Lotus::View::Template.new('apps/web/templates/documents/show_compiled.html.slim') }
  let(:view)      { Web::Views::Documents::ShowCompiled.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #foo" do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
