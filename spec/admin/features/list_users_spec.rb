
# spec/web/features/list_books_spec.rb
require 'features_helper'

describe 'List users' do
  it 'displays the userse' do

    User.create(first_name: 'Jared', last_name: 'Foo-Bar', screen_name: 'jayfoo', password: 'foobar123', password_confirmation: 'foobar123')

    visit '/admin/users'

    assert page.has_content?('Jared Foo-Bar')
  end
end