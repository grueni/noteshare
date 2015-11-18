require 'spec_helper'
require_relative '../../../../apps/image_manager/views/image/search'

describe ImageManager::Views::Image::Search do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Lotus::View::Template.new('apps/image_manager/templates/image/search.html.slim') }
  let(:view)      { ImageManager::Views::Image::Search.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #foo" do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
