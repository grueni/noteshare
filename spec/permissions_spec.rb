require 'spec_helper'
require_relative '../lib/acl'
require_relative '../lib/user_authentication'
require_relative '../spec/features_helper'

include FeatureHelpers::Common

describe Permission do

  before do

    UserRepository.clear
    standard_user_node_doc

    @admin = User.create(first_name: 'Harold', last_name: 'Haroldson', admin: true)
    @janedoe = User.create(first_name: 'Sarah', last_name: 'Samuelson', admin: false)



  end

  it 'can deny access to edit a file to an unquaified user' do

    puts @admin.full_name
    puts @admin.admin
    puts @admin.id

    Permission.new(@admin, :delete, @document).grant.must_equal(true)



  end

end