require 'spec_helper'
require_relative '../../../../apps/uploader/views/file/upload'

describe Uploader::Views::File::Upload do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Lotus::View::Template.new('apps/uploader/templates/file/upload.html.slim') }
  let(:view)      { Uploader::Views::File::Upload.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #foo" do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
