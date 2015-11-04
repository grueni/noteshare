
# spec/web/features/list_books_spec.rb
require 'features_helper'

describe 'List users' do
  it 'displays the userse' do

    UserRepository.create(User.new(first_name: 'Jared', last_name: 'Foo-Bar'))

    visit '/admin/users'

    assert page.has_content?('Jared Foo-Bar')
  end
end