# spec/web/features/visit_home_spec.rb
require 'features_helper'

describe 'Visit home' do
  it 'is successful' do
    visit '/home/'

    page.body.must_include('Noteshare')
    # page.body.must_include('About')

  end
end