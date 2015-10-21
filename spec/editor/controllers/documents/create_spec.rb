# spec/web/controllers/books/create_spec.rb
require 'spec_helper'
require_relative "#{ENV['PROJECT_HOME']}/apps/editor/controllers/documents/create"

describe Editor::Controllers::Books::Create do
  let(:action) { Editor::Controllers::Documents::Create.new }
  let(:params) { Hash[book: { title: 'Confident Ruby', author: 'Avdi Grimm' }] }

  after do
    BookRepository.clear
  end

  it 'creates a new book' do
    action.call(params)
    action.book.id.wont_be_nil
  end

  it 'redirects the user to the books listing' do
    response = action.call(params)

    response[0].must_equal 302
    response[1]['Location'].must_equal '/books'
  end
end