require 'spec_helper'

require 'spec_helper'

require 'json'

# The tests below are mainly concerned with
# setting and persisting attributes
describe Document do

  before do

    DocumentRepository.clear

    @article = DocumentRepository.create(Document.new(title: 'A. Quantum Mechanics', author: 'Jared. Foo-Bar'))
    @section1 = DocumentRepository.create(Document.new(title: 'S1. Uncertainty Principle', author: 'Jared Foo-Bar', subdoc_refs: []))
    @section2 = DocumentRepository.create(Document.new(title: 'S2. Wave-Particle Duality', author: 'Jared Foo-Bar', subdoc_refs: []))
    @section3 = DocumentRepository.create(Document.new(title: 'S3. Matrix Mechanics', author: 'Jared Foo-Bar', subdoc_refs: []))
    @subsection =  DocumentRepository.create(Document.new(title: "SS. de Broglie's idea", author: 'Jared Foo-Bar', subdoc_refs: []))
    @subsubsection =  DocumentRepository.create(Document.new(title: "Yo!", author: 'Jared Foo-Bar', subdoc_refs: []))


    @article.content = 'Quantum phenomena are weird!'
    @section1.content = 'The Uncertainty Principle invalidates the notion of trajectory'
    @section2.content = 'It is, like, _so_ weird!'
    @section3.content = 'Its all about the eigenvalues'
    @subsection.content = 'He was a count.'
    @subsubsection.content = 'Yay!'

    DocumentRepository.persist @article
    DocumentRepository.persist @section1
    DocumentRepository.persist @section2
    DocumentRepository.persist @section3
    DocumentRepository.persist @subsection

  end

  it 'can run an intiaization script' do

    @article = DocumentRepository.find_one_by_title 'A. Quantum Mechanics'
    @section1 = DocumentRepository.find_one_by_title'S1. Uncertainty Principle'
    @section2 = DocumentRepository.find_one_by_title  'S2. Wave-Particle Duality'
    @section3 = DocumentRepository.find_one_by_title  'S3. Matrix Mechanics'
    @subsection = DocumentRepository.find_one_by_title  "SS. de Broglie's idea"


  end


  #### INITALIZATION, SETTING ATTRIBUTES, AND PERSISTENCE ####

  it 'can be initialised with attributes, with defaults set iii' do
    document = Document.new(title: 'Quantum Mechanics', author: 'J.L Foo-Bar')
    document.title.must_equal 'Quantum Mechanics'
    empty_hash = {}
    document.doc_refs.must_equal empty_hash
    document.subdoc_refs.must_equal []
  end

  it 'can save data and later retrieve it by title ttt' do
    doc = DocumentRepository.first
    title = doc.title
    doc2 = DocumentRepository.find_one_by_title(title)
    doc2.title.must_equal title
  end

  it 'can modify doc_refs and later recall the same' do
    title =  'A. Quantum Mechanics'
    title2 = 'Ladidah!'
    doc = DocumentRepository.find_one_by_title(title)
    doc.subdoc_refs = [1,2,3]
    doc.title = title2
    DocumentRepository.update doc
    doc2 = DocumentRepository.find_one_by_title(title2)
    doc2.title.must_equal title2
    doc2.subdoc_refs.must_equal [1,2,3]
  end

  it 'can set the doc_refs hash at will xdr' do

    @article.doc_refs = {}
    @article.doc_refs['foo'] = 'bar'
    @article.doc_refs['foo'].must_equal 'bar'

  end

  #### MANAGING SUBDOCUMENTS ####

  it 'can add subdocuments to a document, setting up refs from parent to child and vice versa sdd1' do

    @section1.add_to(@article)
    @section2.add_to(@article)
    @section3.add_to(@article)

    @article.subdocument_titles.must_equal ["S1. Uncertainty Principle", "S2. Wave-Particle Duality", "S3. Matrix Mechanics"]

    @article.subdocument(0).title.must_equal @section1.title
    @section1.parent_id.must_equal @article.id

    @section1.index_in_parent.must_equal 0
    @section2.index_in_parent.must_equal 1

    @section1.parent.title.must_equal @article.title

  end

  it 'can form a list of subdocument titles sdt' do
    @section1.add_to(@article)
    @section2.add_to(@article)
    @article.subdocument_titles.must_equal ['S1. Uncertainty Principle', 'S2. Wave-Particle Duality']

  end


  #### NEXT AND PREVIOUS


  it 'can computes the next id nxx' do

    @section1.insert(0,@article)
    @section2.insert(1,@article)
    @section3.insert(2,@article)

    @section1.next_id.must_equal @section2.id
    @section2.next_id.must_equal @section3.id
    @section3.next_id.must_equal nil


  end

  it 'can computes the previous id pxx' do

    @section1.insert(0,@article)
    @section2.insert(1,@article)
    @section3.insert(2,@article)

    @section1.previous_id.must_equal nil
    @section2.previous_id.must_equal @section1.id
    @section3.previous_id.must_equal @section2.id

  end


  it 'can find the next document ndoc' do

    @section1.insert(0,@article)
    @section2.insert(1,@article)
    @section3.insert(2,@article)

    @section1.next_document.id.must_equal @section2.id
    @section2.next_document.id.must_equal @section3.id

  end

  it 'can find the previous document pdoc' do

    @section1.insert(0,@article)
    @section2.insert(1,@article)
    @section3.insert(2,@article)

    @section2.previous_document.id.must_equal @section1.id
    @section3.previous_document.id.must_equal @section2.id

  end



  it 'can find the next section of the previous section for a newly appended section qqq' do

    # @section.add_to(@article)
    # @section2.add_to(@article)
    @section1.insert(0, @article)
    @section2.insert(1,@article)
    @section3.insert(2,@article)

    @section1.next_document.title.must_equal @section2.title
    @section2.next_document.title.must_equal @section3.title

    @section2.previous_document.title.must_equal @section1.title
    @section3.previous_document.title.must_equal @section2.title

  end

  it 'can find the previous section for a newly appended section bbb' do

    @section1.insert(0,@article)
    @section2.insert(1,@article)

    @section2.previous_document_title.must_equal @section1.title
    @section1.next_document_title.must_equal @section2.title


  end

  #### COMPILATION

  it 'can compile a document to deeper levels using recursion ccc2' do

    @section1.add_to(@article)
    @section2.add_to(@article)
    @section3.add_to(@article)
    @subsection.add_to(@section2)
    @subsubsection.add_to(@subsection)

    # puts @article.subdocument_titles :header

    text = <<EOF
Quantum phenomena are weird!
The Uncertainty Principle invalidates the notion of trajectory
It is, like, _so_ weird!
He was a count.
Yay!


Its all about the eigenvalues
EOF

    # puts "COMPILED TEXT:"
    # puts "#{@article.compile}"
    # puts "-----------------------"

    @article.compile.must_equal text

  end


end
