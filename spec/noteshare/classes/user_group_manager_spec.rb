require 'spec_helper'
require_relative '../../../lib/noteshare/classes/group/user_group_manager'

include Noteshare::Helper::UserGroup

describe UserGroupManager do

  before do

    @jared = User.create(first_name: 'Jared', last_name: 'Foo-Bar', screen_name: 'jayfoo',
                         password: 'foobar123', password_confirmation: 'foobar123')

  end

  it 'starts with an empty group list for a new user' do

    ugm = UserGroupManager.new(@jared)
    ugm.list.must_equal []

  end

  it 'can add a new group to a user' do

    ugm = UserGroupManager.new(@jared)
    ugm.add('work')
    ugm.list.must_equal ['work']

  end

  it 'can delete a group from a user' do

    ugm = UserGroupManager.new(@jared)
    ugm.add('work')
    ugm.list.must_equal ['work']
    ugm.delete('work')
    ugm.list.must_equal []

  end

  it 'can list the groups of a user in html form' do

    ugm = UserGroupManager.new(@jared)
    ugm.add('work')
    ugm.add('novel')
    ugm.list(:html).must_include '<li>work</li>'
    ugm.list(:html).must_include '<li>novel</li>'

  end

  it 'can add document with permissions to a group or change those permissions' do

    document = NSDocument.create(title: 'Introductory Magick')
    ugm = UserGroupManager.new(@jared)
    ugm.add('work')
    ugm.set(document: document, group_name: 'work', permission: :r)
    document.acl_get('group:work').must_equal 'r'
    ugm.set(document: document, group_name: 'work', permission: :rw)
    document.acl_get('group:work').must_equal 'rw'
    document.acl.inspect.must_equal '{"group:work"=>"rw"}'
    puts document.acl.inspect.red
    ugm.set(document: document, group_name: 'work', permission: :none)
    document.acl.inspect.must_equal '{"group:work"=>"-"}'

  end

end
