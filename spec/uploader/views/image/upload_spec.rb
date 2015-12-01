require 'spec_helper'
require_relative '../../../../apps/uploader/views/image/upload'

describe Uploader::Views::Image::Upload do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Lotus::View::Template.new('apps/uploader/templates/image/upload.html.slim') }
  let(:view)      { Uploader::Views::Image::Upload.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #foo" do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
