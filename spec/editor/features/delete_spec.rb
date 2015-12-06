
require 'features_helper'

describe 'Delete document' do

  before do

    UserRepository.clear
    DocumentRepository.clear

    session = {}

    password = 'foobar12345'
    user = User.create(first_name: 'Jared', last_name: 'Foo-Bar', screen_name: 'jayfoo',
                         password: password, password_confirmation: password)
    authenticator = UserAuthentication.new(user.email, password)
    @user = authenticator.login(session)

    @document = NSDocument.create(title: 'Test', author_credentials: @user.credentials)

  end


  it 'has a valid document for testing aaa' do

    @user.full_name.must_equal('Jared Foo-Bar')
    @document.title.must_equal('Test')
    doc2 = DocumentRepository.find @document.id
    doc2.title.must_equal(@document.title)

  end


  it 'can visit the delete document page' do

    visit "/editor/prepare_to_delete_document/#{@document.id}"
    assert_match /Delete document #{@document.title}/, page.body, "Expected to find standard page heading for document"

  end

  it 'can delete a document' do

    visit "/editor/prepare_to_delete_document/#{@document.id}"
    current_path.must_equal("/prepare_to_delete_document/#{@document.id}")
    assert_match /Delete document #{@document.title}/, page.body, "Expected to find standard page heading for document"

    within 'form#document-form' do
      fill_in 'Destroy',  with: 'destroy'
      click_button 'Destroy'
    end

    current_path.must_equal("/delete_document/#{@document.id}")       ###????

    visit "/delete_document/#{@document.id}"
    puts "current path: #{current_path}".red
    page.body.must_equal("#{@document.title} has been deleted")


  end


end
