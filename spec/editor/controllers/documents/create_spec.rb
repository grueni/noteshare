require 'spec_helper'
require_relative '../../../../apps/editor/controllers/documents/create'

describe Editor::Controllers::Documents::Create do

  let(:action) { Editor::Controllers::Documents::Create.new }
  let(:params) { Hash[document: { title: 'Confident Ruby', author: 'Avdi Grimm', content: 'ho ho ho' }] }

  after do
    DocumentRepository.clear
  end

  it 'creates a new document' do
    action.call(params)
    action.document.id.wont_be_nil
  end

  it 'redirects the user to the documents listing' do
    response = action.call(params)

    skip response[0].must_equal 302
    response[1]['Location'].must_equal '/documents'
  end
end