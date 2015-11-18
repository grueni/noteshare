=begin
require 'spec_helper'
require_relative '../../../../apps/image_manager/views/new_image/new'

describe ImageManager::Views::NewImage::Accept do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Lotus::View::Template.new('apps/image_manager/templates/new_image/accept.html.slim') }
  let(:view)      { ImageManager::Views::NewImage::Accept.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #foo" do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
=end