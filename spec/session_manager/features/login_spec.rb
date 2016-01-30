# spec/web/features/list_documents_spec.rb
require 'features_helper'
include FeatureHelpers::Common


describe 'Login User' do

  before do
    UserRepository.clear
    NSNodeRepository.clear
    standard_user_node_doc
  end

  it 'can bring up the login form 111' do
    visit '/session_manager/login'
    assert page.has_content?('Password')
  end

  it 'can log a user in 222' do

    visit2 nil,  '/session_manager/login'

    within 'form#user-form' do
      fill_in 'Email',  with: 'jayfoo@bar.com'
      fill_in 'Password', with: 'foobar123'

      click_button 'Log in'
    end

    visit2 @user, "/node/user/#{@user.id}"
    assert page.has_content?(@user.screen_name), "Go to user's node page"

  end

end

