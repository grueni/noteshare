require 'spec_helper'
require_relative '../../lib/ui/links'
require 'pry'

include UI::Links
# include Noteshare::Core::Document


describe UI::Links do

  it 'can retrieve the site title' do

    assert site_title == ENV['DOMAIN'].sub('.','')

  end



end

