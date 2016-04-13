# spec/web/features/list_documents_spec.rb
require 'features_helper'

describe 'Create User' do

  before do

    UserRepository.clear
    # User.create(first_name: 'Jared', last_name: 'Foo-Bar', screen_name: 'jayfoo', password: 'foobar123', password_confirmation: 'foobar123')

  end

  it 'can bring up a form for a user record' do
    visit '/session_manager/new_user'
    assert page.has_content?('Password')
  end

  it 'can create a new user record' do

    visit '/session_manager/new_user'

    within 'form#user-form' do
      fill_in 'First name',  with: 'Jordan'
      fill_in 'Last name', with: 'Boomstead'
      fill_in 'Email', with: 'jb@foo.io'
      fill_in 'Password', with: 'hocuspocus1234'
      fill_in 'Password confirmation', with: 'hocuspocus1234'

      click_button 'Create account'
     end


  end

end

