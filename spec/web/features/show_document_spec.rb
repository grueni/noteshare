
require 'features_helper'

describe 'Show document' do

  before do
    DocumentRepository.clear
    @user = User.create(first_name: 'Curtis', last_name: 'Corto', screen_name: 'cc', password:'foobar123', password_confirmation:'foobar123')
    @document = NSDocument.create(title: 'Compendium Vitae', author_credentials: @user.credentials)
    @document.content = "Formula: $a^2 + b^2 = c^2$"
    DocumentRepository.update @document
  end


  it 'has a valid document for testing' do
    doc = DocumentRepository.find_by_title('Compendium Vitae').first
    doc.title.must_equal('Compendium Vitae')
  end


  it 'can visit the page and see the document' do

    visit "/document/#{@document.id}"
    assert_match /Compendium Vitae/, page.body, "Expected to find title of document"
    assert (page.body.include? 'Formula'), "'Formula', present in input, is present in output"
    assert (page.body.include? '\\(a^2 + b^2 = c^2\\)'), "Tex formula is properly renderedt"

  end


end
