require 'spec_helper'
require_relative '../../../lib/noteshare/classes/document_manager'


describe DocumentManager do

  it 'can insert a document into a master document' do

    doc = NSDocument.create(title: 'Master')
    doc.title.must_equal 'Master'
    subdoc = NSDocument.create(title: 'Intro')
    subdoc.title.must_equal 'Intro'
    document_manager = DocumentManager.new(doc)
    document_manager.insert(subdocument: subdoc, position: 0)
    doc.subdocument(0).title.must_equal('Intro')

  end



end