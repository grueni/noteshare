# spec/web/features/list_documents_spec.rb
require 'features_helper'

describe 'List Docs' do

  before do
    DocumentRepository.clear

    DocumentRepository.create(NSDocument.new(title: 'OS Z', author: 'Melvin Luck'))
    DocumentRepository.create(NSDocument.new(title: 'Electromagnetic Theory', author: 'Coram Daag'))
  end

  it 'shows a document element for each document' do
    visit '/documents'
    assert page.has_content?('OS Z')
    assert page.has_content?('Electromagnetic Theory')
    # skip page.has_css?('.document', count: 2), "Expected to find 2 books"
  end

end