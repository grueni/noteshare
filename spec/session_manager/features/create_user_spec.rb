# spec/web/features/list_documents_spec.rb
require 'features_helper'

describe 'Create User' do

  before do

  end

  it 'can create a user record' do
    visit '/session_manager/new_user'
    assert page.has_content?('Password')
  end

end

