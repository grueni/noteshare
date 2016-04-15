require 'spec_helper'
require_relative '../../../lib/noteshare/classes/document/document_manager'

include ::Noteshare::Core::Document

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

  it 'can add a document as a sibling of a given subdocument of a master document' do

    doc = NSDocument.create(title: 'Master')
    doc.title.must_equal 'Master'
    document_manager = DocumentManager.new(doc)

    intro = NSDocument.create(title: 'Intro')
    document_manager.insert(subdocument: intro, position: 0)
    doc.subdocument(0).title.must_equal('Intro')

    esthetics = NSDocument.create(title: 'Esthetics')
    document_manager.add_as_sibling(new_sibling: esthetics, direction: :after, old_sibling: intro )
    doc.subdocument(1).title.must_equal 'Esthetics'

    preface = NSDocument.create(title: 'Preface')
    document_manager.add_as_sibling(new_sibling: preface, direction: :before, old_sibling: intro )
    doc.subdocument(0).title.must_equal 'Preface'

    toc = TOC.new(doc)
    # puts toc.display
    toc.table.count.must_equal 3

  end

  it 'can append a document to a master document' do

    doc = NSDocument.create(title: 'Master')
    doc.title.must_equal 'Master'
    document_manager = DocumentManager.new(doc)

    preface = NSDocument.create(title: 'Preface')
    document_manager.append(preface)
    doc.subdocument(0).title.must_equal 'Preface'

    intro = NSDocument.create(title: 'Intro')
    document_manager.append(intro)
    doc.subdocument(1).title.must_equal('Intro')

    esthetics = NSDocument.create(title: 'Esthetics')
    document_manager.append(esthetics)
    doc.subdocument(2).title.must_equal 'Esthetics'

    toc = TOC.new(doc)
    # puts toc.display
    toc.table.count.must_equal 3

  end

  it 'can remove a document from a master document' do

    doc = NSDocument.create(title: 'Master')
    doc.title.must_equal 'Master'
    document_manager = DocumentManager.new(doc)

    preface = NSDocument.create(title: 'Preface')
    document_manager.append(preface)

    intro = NSDocument.create(title: 'Intro')
    document_manager.append(intro)

    esthetics = NSDocument.create(title: 'Esthetics')
    document_manager.append(esthetics)

    document_manager.remove(intro)
    doc.subdocument(0).title.must_equal 'Preface'
    doc.subdocument(1).title.must_equal 'Esthetics'

    toc = TOC.new(doc)
    # puts toc.display
    toc.table.count.must_equal 2

  end

  it 'can delete a document from a master document' do

    doc = NSDocument.create(title: 'Master')
    doc.title.must_equal 'Master'
    document_manager = DocumentManager.new(doc)

    preface = NSDocument.create(title: 'Preface')
    document_manager.append(preface)

    intro = NSDocument.create(title: 'Intro')
    document_manager.append(intro)

    esthetics = NSDocument.create(title: 'Esthetics')
    document_manager.append(esthetics)

    toc = TOC.new(doc)
    toc.table.count.must_equal 3

    document_manager.delete(intro)
    toc = TOC.new(doc)
    toc.table.count.must_equal 2
    doc.subdocument(0).title.must_equal 'Preface'
    doc.subdocument(1).title.must_equal 'Esthetics'




  end

  it 'can move a document from a given position to a lower position' do

    doc = NSDocument.create(title: 'Master')
    doc.title.must_equal 'Master'
    document_manager = DocumentManager.new(doc)

    a = NSDocument.create(title: 'A')
    document_manager.append(a)

    b = NSDocument.create(title: 'B')
    document_manager.append(b)

    c = NSDocument.create(title: 'C')
    document_manager.append(c)

    document_manager.move(c,0)

    toc = TOC.new(doc)
    doc.subdocument(0).title.must_equal 'C'
    doc.subdocument(1).title.must_equal 'A'
    doc.subdocument(2).title.must_equal 'B'

  end

  it 'can move a document from a given position to a higher position' do

    doc = NSDocument.create(title: 'Master')
    doc.title.must_equal 'Master'
    document_manager = DocumentManager.new(doc)

    a = NSDocument.create(title: 'A')
    document_manager.append(a)

    b = NSDocument.create(title: 'B')
    document_manager.append(b)

    c = NSDocument.create(title: 'C')
    document_manager.append(c)

    document_manager.move(a,1)

    doc.subdocument(0).title.must_equal 'B'
    doc.subdocument(1).title.must_equal 'A'
    doc.subdocument(2).title.must_equal 'C'

  end

  it 'can move a document from a given position to the end' do

    doc = NSDocument.create(title: 'Master')
    doc.title.must_equal 'Master'
    document_manager = DocumentManager.new(doc)

    a = NSDocument.create(title: 'A')
    document_manager.append(a)

    b = NSDocument.create(title: 'B')
    document_manager.append(b)

    c = NSDocument.create(title: 'C')
    document_manager.append(c)

    document_manager.move(a,2)

    doc.subdocument(0).title.must_equal 'B'
    doc.subdocument(1).title.must_equal 'C'
    doc.subdocument(2).title.must_equal 'A'

  end



end