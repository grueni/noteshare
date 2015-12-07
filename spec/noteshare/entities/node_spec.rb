require 'spec_helper'

describe NSNode do

  before do
    NSNodeRepository.clear

  end

  it 'can count its objects' do

    NSNodeRepository.all.count.must_equal 0

    node = NSNode.new(name: 'foo')
    NSNodeRepository.create node
    NSNodeRepository.all.count.must_equal 1

  end

  it 'can find its objects' do

    NSNodeRepository.all.count.must_equal 0

    node = NSNode.new(name: 'foo')
    NSNodeRepository.create node
    NSNodeRepository.all.count.must_equal 1

  end

  it 'can create a node for a user' do

    @user = User.create(first_name: 'Jared', last_name: 'Foo-Bar', screen_name: 'jayfoo',
                        password: 'foobar123', password_confirmation: 'foobar123')

    @document = NSDocument.create(title: 'Test', author_credentials: @user.credentials)
    @node =  NSNode.create_for_user(@user)
    @node.update_docs_for_owner
    @node.docs.must_equal("[{\"id\":#{@document.id},\"title\":\"Test\"}]")

  end


end
