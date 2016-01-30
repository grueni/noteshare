
# spec/web/features/list_books_spec.rb
require 'features_helper'
include FeatureHelpers::Common

describe 'List users' do
  it 'displays the users' do

    User.create(first_name: 'Jared', last_name: 'Foo-Bar', screen_name: 'jayfoo', password: 'foobar123', password_confirmation: 'foobar123')

    #Fixme, should log in an admin user, etc
    standard_user_node_doc
    login_standard_user

    visit2 @user, '/admin/users'

    assert page.has_content?('Jared Foo-Bar')

  end
end