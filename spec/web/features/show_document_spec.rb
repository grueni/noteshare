
require 'features_helper'

describe 'Show document' do

  before do
    DocumentRepository.clear
    @user = User.create(first_name: 'Curtis', last_name: 'Corto', screen_name: 'cc', password:'foobar123', password_confirmation:'foobar123')
    @document = NSDocument.create(title: 'Compendium Vitae', author_credentials: @user.credentials)
    @document.content = ""
    puts "#{@document.title}".red
  end


  it 'has a valid document for testing' do
    doc = DocumentRepository.find_by_title('Compendium Vitae').first
    doc.title.must_equal('Compendium Vitae')
  end


  it 'can visit the page and see the document' do


    puts "/document/#{@document.id}".cyan

    visit "/document/#{@document.id}"
    assert_match /Compendium Vitae/, page.body, "Expected to find title of document"

  end


end
