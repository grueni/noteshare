# spec/web/features/list_documents_spec.rb
require 'features_helper'

describe 'Login User' do

  before do

    UserRepository.clear
    @user = User.create(first_name: 'Jared', last_name: 'Foo-Bar', email: 'jayfoo@bar.com', screen_name: 'jayfoo', password: 'foobar123', password_confirmation: 'foobar123')

    NSNodeRepository.clear
    NSNode.create_for_user(@user)
  end

  it 'can bring up the login form' do
    visit '/session_manager/login'
    assert page.has_content?('Password')
  end

  it 'can create log a user in' do

    visit '/session_manager/login'

    within 'form#user-form' do
      fill_in 'Email',  with: 'jayfoo@bar.com'
      fill_in 'Password', with: 'foobar123'

      click_button 'Log in'
    end

    current_path.must_equal("/user/#{@user.id}")       ###????

    visit "/node/user/#{@user.id}"
    assert page.has_content?(@user.screen_name), "Go to user's node page"

  end

end

