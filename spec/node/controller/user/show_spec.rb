require 'spec_helper'
require_relative '../../../../apps/node/controllers/user/show'

describe Node::Controllers::User::Show do

  let(:action)  { Node::Controllers::User::Show.new }
  let(:format)  { 'application/json' }
  let(:id) { 'epsilon' }

  it "is successful" do
    response = action.call(id: 'epsilon', 'HTTP_ACCEPT' => format)

    puts "HI THERE!".red

    puts response.inspect
    puts response[0]  #.must_equal                 200
    # response[1]['Content-Type'].must_equal "#{ format }; charset=utf-8"
    # response[2].must_equal                 ["ID: #{ user_id }"]
  end
end