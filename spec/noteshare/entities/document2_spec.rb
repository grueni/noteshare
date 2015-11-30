require 'spec_helper'

require 'json'

# The tests below are mainly concerned with
# setting and persisting attributes
describe NSDocument do

  before do

    DocumentRepository.clear

    @article = DocumentRepository.create(NSDocument.new(title: 'A. Quantum Mechanics', author: 'Jared. Foo-Bar'))
    @section1 = DocumentRepository.create(NSDocument.new(title: 'S1. Uncertainty Principle', author: 'Jared Foo-Bar', subdoc_refs: []))
    @section2 = DocumentRepository.create(NSDocument.new(title: 'S2. Wave-Particle Duality', author: 'Jared Foo-Bar', subdoc_refs: []))
    @section3 = DocumentRepository.create(NSDocument.new(title: 'S3. Matrix Mechanics', author: 'Jared Foo-Bar', subdoc_refs: []))
    @subsection =  DocumentRepository.create(NSDocument.new(title: "SS. de Broglie's idea", author: 'Jared Foo-Bar', subdoc_refs: []))
    @subsubsection =  DocumentRepository.create(NSDocument.new(title: "Yo!", author: 'Jared Foo-Bar', subdoc_refs: []))


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
    DocumentRepository.persist @subsubsection

  end

  it 'can run an intiaization script' do

    @article = DocumentRepository.find_one_by_title 'A. Quantum Mechanics'
    @section1 = DocumentRepository.find_one_by_title'S1. Uncertainty Principle'
    @section2 = DocumentRepository.find_one_by_title  'S2. Wave-Particle Duality'
    @section3 = DocumentRepository.find_one_by_title  'S3. Matrix Mechanics'
    @subsection = DocumentRepository.find_one_by_title  "SS. de Broglia"


  end


  #### INITALIZATION, SETTING ATTRIBUTES, AND PERSISTENCE ####

  it 'can be initialised with attributes, with defaults set iii' do
    document = NSDocument.new(title: 'Quantum Mechanics', author: 'J.L Foo-Bar')
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

  it 'persists subdoc_refs pppe' do
    title =  'A. Quantum Mechanics'
    title2 = 'Ladidah!'
    doc = DocumentRepository.find_one_by_title(title)
    doc.subdoc_refs = [1,2,3]
    doc.title = title2
    DocumentRepository.update doc
    doc2 = DocumentRepository.find_one_by_title(title2)
    doc2.title.must_equal title2
    doc2.subdoc_refs.must_equal [1,2,3]

    doc.subdoc_refs = [4,5,6]
    doc.title = 'Foo'
    DocumentRepository.update doc
    doc2 = DocumentRepository.find_one_by_title('Foo')
    doc2.subdoc_refs.must_equal [4,5,6]

  end


  it 'can modify subdoc_refs and later recall the same' do
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

    @article.subdocument(0).title.must_equal @section1.title
    @section1.parent_id.must_equal @article.id

    @section1.index_in_parent.must_equal 0
    @section2.index_in_parent.must_equal 1

    @section1.parent_document.title.must_equal @article.title

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

    @section1.next_document_id.must_equal @section2.id
    @section2.next_document_id.must_equal @section3.id
    @section3.next_document_id.must_equal nil


  end

  it 'can computes the previous id pxx' do

    @section1.insert(0,@article)
    @section2.insert(1,@article)
    @section3.insert(2,@article)

    @section1.previous_document_id.must_equal nil
    @section2.previous_document_id.must_equal @section1.id
    @section3.previous_document_id.must_equal @section2.id

  end


  it 'can find the next document ndoc' do

    @section1.insert(0,@article)
    @section2.insert(1,@article)
    @section3.insert(2,@article)

    @section1.next_document_id.must_equal @section2.id
    @section2.next_document_id.must_equal @section3.id

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

    puts "COMPILED TEXT:"
    puts "#{@article.compile}"
    puts "-----------------------"

    assert @article.compile =~ /eigenvalues/

  end

  #### DELETION

  it 'can delete a subdocument ddd' do

    @section1.add_to(@article)
    @section2.add_to(@article)
    @section3.add_to(@article)
    @section2.remove_from_parent

    p = @section2.parent_document

    p.subdocument(0).next_document.title.must_equal p.subdocument(1).title
    p.subdocument(1).previous_document.title.must_equal p.subdocument(0).title

  end

  it 'can move a subdocument from one position to another mmm' do

    puts "MMM".magenta
    article_id = @article.id
    @section1.add_to(@article)
    @section2.add_to(@article)
    @section3.add_to(@article)

    puts @article.subdocument_titles :verbose
    puts

    @section1.move_to(2)
    #Fixme

    @article = DocumentRepository.find article_id

    puts @article.subdocument_titles :verbose

  end


  it 'manages the root_document pointer rrr' do

    @section1.add_to(@article)
    @section2.add_to(@article)
    @section3.add_to(@article)
    @subsection.add_to(@section2)
    @subsubsection.add_to(@subsection)

    @article.root_document_id.must_equal 0
    @section1.root_document_id.must_equal @article.id
    @subsection.root_document_id.must_equal @article.id
    @subsubsection.root_document_id.must_equal @article.id

  end

  it 'can find the root documnt of any document rr2' do

    @section1.add_to(@article)
    @section2.add_to(@article)
    @section3.add_to(@article)
    @subsection.add_to(@section2)
    @subsubsection.add_to(@subsection)

    @article.root_document.must_equal @article
    @section1.root_document.must_equal @article
    @subsection.root_document.must_equal @article
    @subsubsection.root_document.must_equal @article


  end

  it 'can add recall associated documents ass' do

    notes = DocumentRepository.create(NSDocument.new(title: 'Tables', author: 'Jared. Foo-Bar'))
    notes.associate_to(@article, 'notes')
    puts "@article.doc_refs: #{@article.doc_refs}"
    @article.associated_document('notes').must_equal notes

  end

  it 'can render its content rcc' do

    puts "CONTENT:\n#{@section2.content}"
    @section2.render

    puts
    puts "RENDERED CONTENT:\n#{@section2.rendered_content}"

    @section2.rendered_content.must_include '<em>so</em>'

  end

  it 'can render mathematical content rmm' do

    @section2.content = "He said that $a^2 + b^2 = c^2$. *Wow!*\n[env.theorem]\n--\nThere are infinitely many primes.\n--\n\n"
    @section2.render_options['format'] = 'adoc-latex'
    @section2.render

    puts @section2.rendered_content

    asciidoc_content = "<div class=\"paragraph\">\n<p>He said that \\(a^2 + b^2 = c^2\\). <strong>Wow!</strong></p>\n</div>\n<div class=\"openblock theorem\">\n<div class=\"title\">Theorem 1.</div><div class=\"content\">\n<div class='click_oblique'>\nThere are infinitely many primes.\n</div>\n</div>\n</div>"
    @section2.rendered_content.must_equal asciidoc_content

  end

  it 'sets render_options to { format => adoc} by default roo' do

    hash = { 'format' => 'adoc'}
    @article.render_options.must_equal hash



  end

  it 'can change and persist render_options ro2' do

    @article.render_options['foo'] = 'bar'
    @article.render_options['foo'].must_equal 'bar'
    DocumentRepository.persist(@article)
    @foo = DocumentRepository.find(@article.id)
    @foo.render_options['foo'].must_equal 'bar'


  end

  it 'can find the next oldest ancestor noa' do

    @section1.add_to(@article)
    @section2.add_to(@article)
    @section3.add_to(@article)
    @subsection.add_to(@section2)
    @subsubsection.add_to(@subsection)

    @section2.next_oldest_ancestor.must_equal @section2
    @subsection.next_oldest_ancestor.must_equal @section2
    @subsubsection.next_oldest_ancestor.must_equal @section2

  end

  it 'can compute the level of a document' do

    @section1.content = 'Foo'
    @section1.asciidoc_level.must_equal(0)

      @section1.content = '= Foo'
      @section1.asciidoc_level.must_equal(0)

      @section1.content = '== Foo'
      @section1.asciidoc_level.must_equal(1)

      @section1.content = '=== Foo'
      @section1.asciidoc_level.must_equal(2)

  end






end
