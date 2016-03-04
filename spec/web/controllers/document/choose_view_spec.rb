require 'spec_helper'
require_relative '../../../../apps/web/controllers/document/choose_view'

describe Web::Controllers::Document::ChooseView do
  let(:action) { Web::Controllers::Document::ChooseView.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
