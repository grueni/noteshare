require 'spec_helper'

describe Users do

  before do
    UsersRepository.clear
    UsersRepository.create(Users.new(first_name: 'Jared', last_name: 'Foo-Bar'))
  end
  # place your tests here

  it 'can create and find a user' do

    assert UsersRepository.first.first_name.must_equal 'Jared'

  end


end
