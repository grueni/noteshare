require 'spec_helper'
require_relative '../../../../apps/web/views/home/about'

describe Web::Views::Home::About do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Lotus::View::Template.new('apps/web/templates/home/about.html.slim') }
  let(:view)      { Web::Views::Home::About.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #foo" do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
