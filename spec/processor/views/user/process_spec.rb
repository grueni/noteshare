require 'spec_helper'
require_relative '../../../../apps/processor/views/user/process'

describe Processor::Views::User::Process do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Lotus::View::Template.new('apps/processor/templates/user/process.html.slim') }
  let(:view)      { Processor::Views::User::Process.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #foo" do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
