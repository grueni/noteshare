require 'spec_helper'

include Noteshare::Core::Document

describe NSDocument do


  it 'can associate a one document to another' do

    DocumentRepository.clear
    doc1 = NSDocument.create(title: 'Father')
    doc2 = NSDocument .create(title: 'Son')
    assert doc1.associates.count == 0, 'associate document count must be one before  associatinga a new doc'
    doc2.associate_to doc1, 'note'
    assert doc1.associates.count == 1, 'associate document count must be one after associatinga a new doc'
    puts doc1.associates
  end

  it 'can find an associates document by type' do

    DocumentRepository.clear
    doc1 = NSDocument.create(title: 'Father')
    doc2 = NSDocument .create(title: 'Son')
    assert doc1.associates.count == 0, 'associate document count must be one before  associatinga a new doc'
    doc2.associate_to doc1, 'note'
    doc3 = doc1.associated_document('note')
    assert doc2 == doc3, 'The retrieved associated document is the correct onec'
  end

  it 'can add an associate a document given a hash of attributes' do

    DocumentRepository.clear
    doc1 = NSDocument.create(title: 'Father')
    doc1.add_associate(title: 'Notes from class', type: 'note', content: 'foo, bar')
    assert doc1.associates.count == 1, 'associate document count must be one after  adding associated doc'


  end

  it 'can disassociate an associated document from its parent disss' do

    DocumentRepository.clear
    doc1 = NSDocument.create(title: 'Father')
    # doc2 = doc1.add_associate(title: 'Notes from class', type: 'note', content: 'foo, bar')
    doc2 = AssociateDocumentManager.new(doc1).add(title: 'Notes from class', type: 'note', content: 'foo, bar')
    assert doc1.associates.count == 1, 'associate document count must be one after  adding associated doc'
    AssociateDocumentManager.new(doc1).detach(doc2)
    doc1 = DocumentRepository.find doc1.id
    assert doc1.associates.count == 0, 'associate document count must be zero after disassociating doc2 from doc1'

  end

  it 'can delete an associated document from its parent' do

    DocumentRepository.clear
    doc1 = NSDocument.create(title: 'Father')
    doc2 = doc1.add_associate(title: 'Notes from class', type: 'note', content: 'foo, bar')
    assert doc1.associates.count == 1, 'associate document count must be one after  adding associated doc'
    doc2.disassociate
    doc1 = DocumentRepository.find doc1.id
    assert doc1.associates.count == 0, 'associate document count must be zero after disassociating doc2 from doc1'

  end




end