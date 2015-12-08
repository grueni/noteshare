require 'spec_helper'
require_relative '../../../../apps/test/controllers/graph/experiment1'

describe Test::Controllers::Graph::Experiment1 do
  let(:action) { Test::Controllers::Graph::Experiment1.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
