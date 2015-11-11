require 'spec_helper'
require_relative '../../../../apps/web/controllers/documents/show_compiled'

describe Web::Controllers::Documents::ShowCompiled do
  let(:action) { Web::Controllers::Documents::ShowCompiled.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
