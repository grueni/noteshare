require 'spec_helper'
require_relative '../../../../apps/image_manager/views/image/update'

describe ImageManager::Views::Image::Update do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Lotus::View::Template.new('apps/image_manager/templates/image/update.html.slim') }
  let(:view)      { ImageManager::Views::Image::Update.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #foo" do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
