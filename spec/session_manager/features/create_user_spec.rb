# spec/web/features/list_documents_spec.rb
require 'features_helper'

describe 'Create User' do

  before do

  end

  it 'can bring up a form for a user record' do
    visit '/session_manager/new_user'
    assert page.has_content?('Password')
  end

  it 'can create a new user record' do

    visit '/session_manager/new_user'

    within id = 'user_setup_form' do
      fill_in 'First name',  with: 'Jordan'
      fill_in 'Last name', with: 'Boomstead'
      fill_in 'Email', with: 'jb@foo.io'
      fill_in 'Password', with: 'hocuspocus1234'
      fill_in 'Password confirmation', with: 'hocuspocus1234'

      click_button 'Create account'
     end

    current_path.must_equal('/')
    assert page.has_content?('Home')
  end

  it 'shows a user' do
    visit '/admin/users'
    user = UserRepository.first
    assert page.has_content?(user.last_name)
  end

end

