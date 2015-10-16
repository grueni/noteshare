require 'spec_helper'

describe DocumentRepository do

    before do
      DocumentRepository.clear

      @document = DocumentRepository.create(Document.new(title: 'TDD', author: 'Kent Beck'))
    end

    it 'persists objects ppp' do
      doc = DocumentRepository.find @document.id
      doc.title.must_equal 'TDD'
    end

    it 'finds objects by title fff' do
      docs = DocumentRepository.find_by_title 'TDD'
      docs.first.title.must_equal 'TDD'
    end


end
