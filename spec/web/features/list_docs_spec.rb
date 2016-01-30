# spec/web/features/list_documents_spec.rb
require 'features_helper'
include FeatureHelpers::Common


describe 'List Docs' do

  before do
    DocumentRepository.clear
    standard_user_node_doc

    @document2 = NSDocument.create(title:  'OS Z', author_credentials: @user.credentials)
    @document2.acl_set_permissions('rw', 'r', 'r')
    DocumentRepository.update @document2

    @document3 = NSDocument.create(title:  'Electromagnetic Theory', author_credentials: @user.credentials)
    @document3.acl_set_permissions('rw', 'r', '-')
    @document3.author_id = @user.id
    DocumentRepository.update @document3
  end

  it 'shows public documents to a non-logged in user 111' do

    visit '/documents'
    assert page.has_content?('Test'), "Has content Test"
    assert page.has_content?('OS Z'), "Has content OS Z"
    assert page.has_content?('Electromagnetic Theory') == false, "Has content Electromagnetic Theory (1)"

  end

  it 'shows a document element for each document 222' do

    skip
    puts "doc count: #{DocumentRepository.all.count}".magenta

    login_standard_user

    puts "@document3 author_id = #{@document3.author_id}".red
    puts "@document3 title = #{@document3.title}".cyan
    puts "@document3 author_id = #{@document3.author_id}".cyan

    puts "@user id = #{@user.id}".red
    p = Permission.new(@user, :read, @document3).grant
    puts "p = #{p}".red
    q = can_read(@user).call(@document3)
    puts "q = #{q}".cyan
    puts "@user_full_name = #{@user.full_name}".red

    visit2 @user, '/documents'
    # assert page.has_css?('lightlink', count: 2), "Expected to find 2 books"
    assert page.has_content?('Test'), "Has content Test"
    assert page.has_content?('OS Z'), "Has content OS Z"
    # puts page.body.cyan
    assert page.has_content?('Electromagnetic Theory'), "Has content Electromagnetic Theory (2)"

  end

end