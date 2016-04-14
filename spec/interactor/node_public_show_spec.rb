require 'spec_helper'
require_relative '../../lib/noteshare/interactors/editor/read_document'
require 'pry'

include Noteshare::Interactor::Node
include Noteshare::Core::Node


describe PublicShow do

  before do

    @user = User.create(first_name: 'Jared', last_name: 'Foo-Bar', email: 'jayfoo@bar.com',
                        screen_name: 'jayfoo', password: 'foobar123', password_confirmation: 'foobar123')

    @node = NSNode.create('foo', @user.id, 'public','foo')
    NSNodeRepository.update @node
    
  end

  it 'can blah blah' do

    @payload = PublicShow.new(user: @user, node_name: @node.name).call
    assert @payload.user.id == @user.id

  end


end