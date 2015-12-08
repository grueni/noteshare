require 'spec_helper'
require_relative '../../../../apps/editor/controllers/test/toc'

describe Editor::Controllers::Test::Toc do
  let(:action) { Editor::Controllers::Test::Toc.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
