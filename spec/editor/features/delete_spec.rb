
require 'features_helper'

describe 'Delete document' do

  before do

    UserRepository.clear
    NSNodeRepository.clear
    DocumentRepository.clear

    @user = User.create(first_name: 'Jared', last_name: 'Foo-Bar', email: 'jayfoo@bar.com',
                        screen_name: 'jayfoo', password: 'foobar123', password_confirmation: 'foobar123')

    NSNode.create_for_user(@user)

    @document = NSDocument.create(title: 'Test', author_credentials: @user.credentials)

  end


  it 'has a valid document for testing' do

    @document.title.must_equal('Test')
    doc2 = DocumentRepository.find @document.id
    doc2.title.must_equal(@document.title)

  end


  it 'can visit the delete document page' do

    visit "/editor/prepare_to_delete_document/#{@document.id}"
    assert_match /Delete document #{@document.title}/, page.body, "Expected to find standard page heading for document"

  end

  it 'can delete a document' do

    visit '/session_manager/login'

    within 'form#user-form' do
      fill_in 'Email',  with: 'jayfoo@bar.com'
      fill_in 'Password', with: 'foobar123'

      click_button 'Log in'
    end

    current_path.must_equal("/user/#{@user.id}")

    visit "/node/user/#{@user.id}"
    assert page.has_content?(@user.screen_name), "Go to user's node page"


    visit "/editor/prepare_to_delete_document/#{@document.id}"
    current_path.must_equal("/prepare_to_delete_document/#{@document.id}")
    assert_match /Delete document #{@document.title}/, page.body, "Expected to find standard page heading for document"

    within 'form#document-form' do
      fill_in 'Destroy',  with: 'destroy'
      click_button 'Destroy'
    end

    current_path.must_equal("/delete_document/#{@document.id}")

    puts page.body.cyan
    page.body.must_include("#{@document.title} has been deleted")


  end


end
