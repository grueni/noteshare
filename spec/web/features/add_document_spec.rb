# spec/web/features/add_book_spec.rb
require 'features_helper'

describe 'Documents' do
  after do
    DocumentRepository.clear
  end
=begin
  it 'can create a new document' do
    visit '/documents/new'

    within 'form#document-form' do
      fill_in 'Title',  with: 'New document'
      fill_in 'Author', with: 'Author'

      click_button 'Create'
    end

    current_path.must_equal('/documents')
    assert page.has_content?('New document')
  end
=end
end