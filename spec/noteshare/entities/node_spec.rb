require 'spec_helper'

include Noteshare::Core::Node
include Noteshare::Core::Document

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

    #Fixme. having to put both author_credentials and author_id is dangerous
    @document = NSDocument.create(title: 'Test', author_credentials: @user.credentials, author_id: @user.id, root_document_id: 0)

    @node =  NSNode.create_for_user(@user)
    @node.update_docs_for_owner

    publications = Publications.records_for_node(@node.id)
    publications.count.must_equal(1)

  end


end
