require 'spec_helper'
require 'json'

describe User do

  before do
    UserRepository.clear
    @jared = User.create(first_name: 'Jared', last_name: 'Foo-Bar', screen_name: 'jayfoo', password: 'foobar123', password_confirmation: 'foobar123')
  end


  it 'can create and find a user' do

    user =  UserRepository.first
    assert user.first_name.must_equal 'Jared'
    assert user.last_name.must_equal 'Foo-Bar'
    assert user.id > 0
    assert user.identifier.length == 20
    puts user.id
    puts user.identifier

  end

  it 'can set, update and read the dict a user' do

    data = { node: 23 }
    @jared.dict_set(data)
    @jared.dict_lookup('node').must_equal(23)

    @jared.dict_update(node: 66)
    @jared.dict_lookup('node').must_equal(66)

  end

  it 'can update the dict of a user in nil ases' do

    @jared.dict_update(node: 66)
    @jared.dict_lookup('node').must_equal(66)

  end


  it 'can set and read the node_id of a user' do

    @jared.dict_update(node: 33)
    @jared.node_id.must_equal(33)

  end


end
