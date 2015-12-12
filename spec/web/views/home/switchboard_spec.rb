require 'spec_helper'
require_relative '../../../../apps/web/views/home/switchboard'

describe Web::Views::Home::Switchboard do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Lotus::View::Template.new('apps/web/templates/home/switchboard.html.slim') }
  let(:view)      { Web::Views::Home::Switchboard.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #foo" do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
