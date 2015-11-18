require 'spec_helper'
require_relative '../../../../apps/image_manager/views/image/list'

describe ImageManager::Views::Image::List do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Lotus::View::Template.new('apps/image_manager/templates/image/list.html.slim') }
  let(:view)      { ImageManager::Views::Image::List.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #foo" do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
