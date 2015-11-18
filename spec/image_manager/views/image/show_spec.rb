require 'spec_helper'
require_relative '../../../../apps/image_manager/views/image/show'

describe ImageManager::Views::Image::Show do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Lotus::View::Template.new('apps/image_manager/templates/image/show.html.slim') }
  let(:view)      { ImageManager::Views::Image::Show.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #foo" do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
