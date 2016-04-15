require 'spec_helper'
require_relative '../features_helper'
require_relative '../../lib/noteshare/interactors/editor/read_document'
require 'pry'

include Noteshare::Interactor::Document
include ::Noteshare::Core::Document
include Noteshare::Core::Node



describe EditDocument do

  before do

    @user = User.create(first_name: 'Jared', last_name: 'Foo-Bar', email: 'jayfoo@bar.com',
                        screen_name: 'jayfoo', password: 'foobar123', password_confirmation: 'foobar123')
    NSNode.create_for_user(@user)
    @document = NSDocument.create(title: 'Test', author_credentials: @user.credentials)
    @document.acl_set_permissions('rw', 'r', 'r')
    @document.content = "== Introduction\n\nThis is a _test_: $a^2 + b^2 = c^2$"
    DocumentRepository.update @document


  end

  it 'can blah blah' do

    hash = {:document => { 'title' => "Foo's Autobiography" }}

    @payload = CreateDocument.new(hash, @user).call
    assert @payload.error == nil


  end


end