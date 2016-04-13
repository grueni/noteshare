require 'spec_helper'
require_relative '../../../apps/web/views/home/switchboard'

describe Web::Controllers::Home::Switchboard do

  include Rack::Test::Methods

  def app
    Lotus::Container.new
  end


  it "is successful" do
    get "/"

    puts last_response
  end
end