require 'spec_helper'
require_relative '../../../../apps/node/controllers/settings/edit'

describe Node::Controllers::Settings::Edit do
  let(:action) { Node::Controllers::Settings::Edit.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
