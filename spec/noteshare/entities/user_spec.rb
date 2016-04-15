require 'spec_helper'
require 'json'

include HR

describe User do

  before do
    UserRepository.clear
    @jared = User.create(first_name: 'Jared', last_name: 'Foo-Bar', screen_name: 'jayfoo', password: 'foobar123', password_confirmation: 'foobar123')
  end


  it 'can create and find a user 111' do

    user =  UserRepository.first
    assert user.first_name.must_equal 'Jared'
    assert user.last_name.must_equal 'Foo-Bar'
    assert user.id > 0
    assert user.identifier.length == 20
    puts user.id
    puts user.identifier

  end

  it 'can create a user from scratch' do
    user = User.create(first_name: 'John', last_name: 'Smith', password: 'yoyo1234', password_confirmation:  'yoyo1234')
    user.first_name.must_equal('John')
  end

  it 'can set, update and read the dict a user' do

    @jared.set_node 23
    @jared.node_id.must_equal(23)


  end




end
