require 'spec_helper'
require_relative '../../../lib/noteshare/classes/document/associate_document_manager'
require 'pry'

include ::Noteshare::Core::Document


describe AssociateDocumentManager do

  it 'can associate one document to another and then retrieve it 111' do

    master_doc = NSDocument.create(title: 'Master')
    master_doc.title.must_equal 'Master'
    assoc_doc = NSDocument.create(title: 'Notes')
    assoc_doc.title.must_equal 'Notes'

    AssociateDocumentManager.new(master_doc).attach(assoc_doc, 'note')
    assoc_doc2 = AssociateDocumentManager.new(master_doc).get_one('note')
    assoc_doc2.title.must_equal assoc_doc.title
    assoc_doc2.parent_document.must_equal master_doc

  end


  it 'can create a document and attach it 222' do


    @user = User.create(first_name: 'Jared', last_name: 'Foo-Bar', screen_name: 'jayfoo', password: 'foobar123', password_confirmation: 'foobar123')
    UserRepository.create(@user)
    @article = NSDocument.create(title: 'Quantum Mechanics', author_credentials: @user.credentials)
    @content = 'Dr. Smith said that conservation laws ...'
    AssociateDocumentManager.new(@article).add(title: 'Notes from class', type: 'note', content: @content)
    associated_document = AssociateDocumentManager.new(@article).get_one('note')
    associated_document.title.must_equal 'Notes from class'

  end

  it 'can detach a document 333' do

    master_doc = NSDocument.create(title: 'Master')
    master_doc.title.must_equal 'Master'
    assoc_doc = NSDocument.create(title: 'Notes')
    assoc_doc.title.must_equal 'Notes'

    AssociateDocumentManager.new(master_doc).attach(assoc_doc, 'note')
    AssociateDocumentManager.new(master_doc).get_one('note').must_equal assoc_doc
    AssociateDocumentManager.new(master_doc).detach(assoc_doc)
    null_hash = {}
    master_doc.doc_refs.must_equal null_hash


  end

  it 'can delete an associated document' do

    master_doc = NSDocument.create(title: 'Master')
    master_doc.title.must_equal 'Master'
    assoc_doc = NSDocument.create(title: 'Notes')
    assoc_doc.title.must_equal 'Notes'

    AssociateDocumentManager.new(master_doc).attach(assoc_doc, 'note')
    AssociateDocumentManager.new(master_doc).get_one('note').must_equal assoc_doc
    AssociateDocumentManager.new(master_doc).delete(assoc_doc)
    null_hash = {}
    master_doc.doc_refs.must_equal null_hash

    #fixme: improve test
  end


end