require 'spec_helper'

include ::Noteshare::Core::Document
include Noteshare::Helpers::Groups
include UserGroup::Core

describe Groups do

  before do

    @user = User.create(first_name: 'John', last_name: 'Doe', screen_name: 'jd', password: 'foobar123', password_confirmation: 'foobar123')
    @document = NSDocument.create(title: 'Magick', author_credentials: @user.credentials)

  end


  it 'can add a group to a document' do

    @document.add_group('collaborators')
    @document.add_group('friends')
    @document.has_group('collaborators').must_equal(true)


  end


end