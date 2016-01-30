# spec/web/features/add_book_spec.rb
require 'features_helper'
include FeatureHelpers::Common

describe 'Documents' do
  after do
    DocumentRepository.clear
  end

 it 'can create a new document' do

   skip

   standard_user_node_doc
   login_standard_user

    visit '/documents/new'

    within 'form#document-form' do
      fill_in 'Title',  with: 'New document'
      fill_in 'Author', with: 'Author'
      click_button 'Create'
    end

    current_path.must_equal('/documents')
    assert page.has_content?('New section')
  end

end