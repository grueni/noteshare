require 'spec_helper'
require_relative '../../../../apps/uploader/views/file/do_upload'

describe Uploader::Views::File::DoUpload do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Lotus::View::Template.new('apps/uploader/templates/file/do_upload.html.slim') }
  let(:view)      { Uploader::Views::File::DoUpload.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #foo" do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
