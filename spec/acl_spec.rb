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

  it 'can set all permissions for the default user with a single expression' do
    a = ACL.new()
    a.set('rw', 'r', 'r') # default user
    a.get_user('').must_equal('rw')
    a.get_group('').must_equal('r')
    a.get_world.must_equal('r')
  end


  it 'can create an ACL from a set of permissions' do
    a = ACL.create_with_permissions('rw', 'r', '-')
    a.get_user.must_equal('rw')
    a.get_group.must_equal('r')
    a.get_world.must_equal('-')
  end


  it 'can get and set the acl of a document' do
    user = User.create(first_name: 'John', last_name: 'Doe', password: 'foo', password_confirmation: 'foo')
    document = NSDocument.create(title: 'Magick', author_credentials: user.credentials)

    a = ACL.create_with_permissions('rw', 'r', '-')

    document.set_acl(a)
    aa = document.get_acl

    aa.get_user.must_equal(a.get_user)
    aa.get_group.must_equal(a.get_group)
    aa.get_world.must_equal(a.get_world)

  end


  it 'encoded and object as a JSON string and can also decode from a JSON string to an ACL object' do
    a = ACL.create_with_permissions('rw', 'r', '-')
    str = a.to_json
    aa = ACL.parse(str)
    a.get_user.must_equal(aa.get_user)
  end


end