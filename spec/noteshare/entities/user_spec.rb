require 'spec_helper'

describe User do

  before do
    UserRepository.clear
    UserRepository.create(User.new(first_name: 'Jared', last_name: 'Foo-Bar'))
  end
  # place your tests here

  it 'can create and find a user' do

    assert UserRepository.first.first_name.must_equal 'Jared'

  end


end
