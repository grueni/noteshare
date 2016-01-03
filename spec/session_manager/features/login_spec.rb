# spec/web/features/list_documents_spec.rb
require 'features_helper'
include FeatureHelpers::Common


describe 'Login User' do

  before do
    UserRepository.clear
    NSNodeRepository.clear
    standard_user_node_doc
  end

  it 'can bring up the login form' do
    visit '/session_manager/login'
    assert page.has_content?('Password')
  end

  it 'can log a user in' do

    visit '/session_manager/login'

    within 'form#user-form' do
      fill_in 'Email',  with: 'jayfoo@bar.com'
      fill_in 'Password', with: 'foobar123'

      click_button 'Log in'
    end

    current_path.must_equal("/authenticate")       ###????

    visit "/node/user/#{@user.id}"
    assert page.has_content?(@user.screen_name), "Go to user's node page"

  end

end

