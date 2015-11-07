require 'spec_helper'
require 'json'

describe User do

  before do
    UserRepository.clear
    @jared = UserRepository.create(User.new(first_name: 'Jared', last_name: 'Foo-Bar'))
  end


  it 'can create and find a user' do

    assert UserRepository.first.first_name.must_equal 'Jared'

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
