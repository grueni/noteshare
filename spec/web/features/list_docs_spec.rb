# spec/web/features/list_books_spec.rb
require 'features_helper'

describe 'List docs' do
  it 'displays each documents on the page' do
    visit '/documents'

    within '#documents' do
      assert page.has_css?('.document', count: 2), "Expected to find 2 documents"
    end
  end
end