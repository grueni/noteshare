require 'spec_helper'
require_relative '../lib/acl'


describe ACL do

  
  it 'can set and get permissions for the default user' do

    a = ACL.new()

    a.set_user('', 'r')
    a.get_user('').must_equal('r')


  end

  it 'can set and get permissions for a specific user' do

    a = ACL.new()

    a.set_user('joe', 'r')
    a.get_user('joe').must_equal('r')


  end

  it 'can  be set up from a hash' do

    h = {'user:joe' => 'r'}

    a = ACL.init_from_hash(h)
    a.get_user('joe').must_equal('r')

  end


  it 'can set and get permissions for a group' do

    a = ACL.new()
    a.set_group('work','r')
    a.get_group('work').must_equal('r')

  end

  it 'can set and get permissions for the default group' do

    a = ACL.new()
    a.set_group('','r')
    a.get_group('').must_equal('r')

  end

  it 'can set and get permissions for the world' do

    a = ACL.new()
    a.set_world('r')
    a.get_world.must_equal('r')

  end

  it 'can delete permissions for a specific user' do

    a = ACL.new()
    a.set_user('joe', 'r')
    a.delete_user('joe')
    a.get_user('joe').must_equal(nil)
  end

  it 'can delete permissions for a specific group' do

    a = ACL.new()
    a.set_group('work', 'r')
    a.delete_group('work')
    a.get_user('work').must_equal(nil)
  end



end