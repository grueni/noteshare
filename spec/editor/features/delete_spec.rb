
require 'features_helper'
include FeatureHelpers::Session
include  FeatureHelpers::Common
include Noteshare::Core::Node

describe 'Delete document' do

  before do

    UserRepository.clear
    NSNodeRepository.clear
    DocumentRepository.clear

    standard_user_node_doc

  end


  it 'can log in a test user 111' do

    skip

    login_standard_user

  end


  it 'has a valid document for testing 222' do

    skip

    @document.title.must_equal('Test')
    doc2 = DocumentRepository.find @document.id
    doc2.title.must_equal(@document.title)

  end


  it 'can visit the delete document page 333' do

    skip

    login_standard_user
    visit2 @user, "/editor/prepare_to_delete_document/#{@document.id}"
    assert_match /Delete document #{@document.title}/, page.body, "Expected to find standard page heading for document"

  end

  it 'can delete a document 444' do

    skip

    login_standard_user

    visit2 @user, "/node/user/#{@user.id}"
    assert page.has_content?(@user.screen_name), "Go to user's node page"

    visit2 @user, "/editor/prepare_to_delete_document/#{@document.id}"
    current_path.must_equal("/prepare_to_delete_document/#{@document.id}")
    assert_match /Delete document #{@document.title}/, page.body, "Expected to find standard page heading for document"


    within 'form#document-form' do
      fill_in 'Destroy',  with: 'destroy'
      click_button 'Destroy'
    end


    # current_path.must_equal("/delete_document/#{@document.id}")
    page.body.must_include("#{@document.title} has been deleted")
    # Fixme ^^^^


  end

end
