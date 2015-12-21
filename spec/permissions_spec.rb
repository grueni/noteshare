require 'spec_helper'
require_relative '../lib/acl'
require_relative '../lib/user_authentication'
require_relative '../spec/features_helper'

include FeatureHelpers::Common

describe Permission do

  before do

    UserRepository.clear
    standard_user_node_doc # @document.acl_set_permissions('rw', 'r', '-')

    @admin = User.create(first_name: 'Harold', last_name: 'Haroldson', admin: true)
    @janedoe = User.create(first_name: 'Sarah', last_name: 'Samuelson', admin: false)



  end

  it 'grants the administrator access to everything' do

    Permission.new(@admin, :create, @document).grant.must_equal(true)
    Permission.new(@admin, :read, @document).grant.must_equal(true)
    Permission.new(@admin, :edit, @document).grant.must_equal(true)
    Permission.new(@admin, :update, @document).grant.must_equal(true)
    Permission.new(@admin, :delete, @document).grant.must_equal(true)

  end

  it 'denies a generic user access ta a document wth permissins rw, r, -' do

    Permission.new(@janedoe, :create, @document).grant.must_equal(false)
    Permission.new(@janedoe, :read, @document).grant.must_equal(false)
    Permission.new(@janedoe, :edit, @document).grant.must_equal(false)
    Permission.new(@janedoe, :update, @document).grant.must_equal(false)
    Permission.new(@janedoe, :delete, @document).grant.must_equal(false)

  end

  it 'grants a generic user read access ta a document wth permissins rw, r, r //rxx' do

    @document.acl_set_permissions('rx', 'r', 'r')
    DocumentRepository.update @document

    Permission.new(@janedoe, :create, @document).grant.must_equal(false)
    Permission.new(@janedoe, :read, @document).grant.must_equal(true)
    Permission.new(@janedoe, :edit, @document).grant.must_equal(false)
    Permission.new(@janedoe, :update, @document).grant.must_equal(false)
    Permission.new(@janedoe, :delete, @document).grant.must_equal(false)

  end


end