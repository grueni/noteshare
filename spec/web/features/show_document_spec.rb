
require_relative '../../features_helper'

include FeatureHelpers::Common

describe 'Show document' do

  before do
    DocumentRepository.clear
    standard_user_node_doc
    @user = login_standard_user
    puts "@user: #{@user.full_name}".white
    # @user = User.create(first_name: 'Curtis', last_name: 'Corto', screen_name: 'cc', password:'foobar123', password_confirmation:'foobar123')
    @document = NSDocument.create(title: 'Compendium Vitae', author_credentials: @user.credentials)
    @document.content = "Formula: $a^2 + b^2 = c^2$"
    DocumentRepository.update @document
  end


  it 'has a valid document for testing 666' do
    doc = DocumentRepository.find_by_title('Compendium Vitae').first
    doc.title.must_equal('Compendium Vitae')
  end


  it 'can visit the page and see the document 777' do

    puts "USER = #{@user.full_name}".magenta
    visit "/document/#{@document.id}"
    assert_match /Knowledge/, page.body, "Expected to find this text in document"
    assert (page.body.include? 'Formula'), "'Formula', present in input, is present in output"
    assert (page.body.include? '\\(a^2 + b^2 = c^2\\)'), "Tex formula is properly renderedt"

  end


end
