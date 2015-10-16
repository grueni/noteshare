require 'spec_helper'

require 'spec_helper'

require 'json'

describe Document do

  before do

    DocumentRepository.clear

    @article = DocumentRepository.create(Document.new(title: 'A. Quantum Mechanics', author: 'Jared. Foo-Bar'))
    @section = DocumentRepository.create(Document.new(title: 'S1. Uncertainty Principle', author: 'Jared Foo-Bar', subdoc_refs: []))
    @section2 = DocumentRepository.create(Document.new(title: 'S2. Wave-Particle Duality', author: 'Jared Foo-Bar', subdoc_refs: []))
    @section3 = DocumentRepository.create(Document.new(title: 'S3. Matrix Mechanics', author: 'Jared Foo-Bar', subdoc_refs: []))
    @subsection =  DocumentRepository.create(Document.new(title: "SS. de Broglie's idea", author: 'Jared Foo-Bar', subdoc_refs: []))

    @article.content = 'Quantum phenomena are weird!'
    @section.content = 'The Uncertainty Principle invalidates the notion of trajectory'
    @section2.content = 'It is, like, _so_ weird!'
    @subsection.content = 'He was a count.'

    DocumentRepository.persist @article
    DocumentRepository.persist @section
    DocumentRepository.persist @section2
    DocumentRepository.persist @section3
    DocumentRepository.persist @subsection

    puts '**********************************'
    puts @section2.subdocument_titles :header
    puts @section2.subdoc_refs
    puts '**********************************'

  end

  it 'can be initialised with attributes, with default set iii' do
    document = Document.new(title: 'Quantum Mechanics', author: 'J.L Foo-Bar')
    document.title.must_equal 'Quantum Mechanics'
    empty_hash = {}
    document.doc_refs.must_equal empty_hash
   document.subdoc_refs.must_equal []
  end

  it 'can find the next document nxx' do
    @article.next_document
  end

  it 'can add subdocuments to a document, setting up refs from parent to child and vice versa' do

    @section.add_to(@article)
    @section2.add_to(@article)

    @article.subdocument(0).title.must_equal @section.title
    @section.parent_id.must_equal @article.id

    @section.index_in_parent.must_equal 0
    @section2.index_in_parent.must_equal 1

    @section.parent.title.must_equal @article.title

  end

  ######### next and prev #####

  it 'can set the doc_refs hash at will xdr' do

    @artcile.doc_refs = {}
    @article.doc_refs['foo'] = 'bar'
    @article.doc_refs['foo'].must_equal 'bar'

  end

  it 'can set the next and previous doc aaa' do
    @section.add_to(@article)
    @section.set_previous_doc(666)
    @section.set_next_doc(777)

    @section.doc_refs['previous'].must_equal 666
    @section.doc_refs['next'].must_equal 777

    puts "STATUS #{@section.status}"
  end

  it 'can find the previous section for a newly appended section bbb' do

    @section.insert(0,@article)
    @section2.insert(1,@article)

    puts @section.status
    puts @section2.status

    puts

    puts @article.subdocument_titles(:verbose)
    hash = {'previous'=> @section.id}
    puts  @section2.doc_refs

    @section2.doc_refs.must_equal hash
    @section2.previous_document_title.must_equal @section.title


  end



  it 'can find the next section of the previous section for a newly appended section qqq' do

    # @section.add_to(@article)
    # @section2.add_to(@article)
    @section.insert(0, @article)
    @section2.insert(1,@article)
    @section3.insert(2,@article)
    hash = {'next'=> @section2.id}

    puts "\n----------------------\n"

    puts @section.status
    puts @section2.status
    puts @section3.status

    puts

    puts @article.subdocument_titles(:verbose)

    puts

    puts @section.status
    puts @section2.status
    puts @section3.status

    puts "----------------------\n"

    puts "@section.title: #{@section.title}"
    puts "@section.doc_refs: #{@section.doc_refs}"
    @section.doc_refs.must_equal hash
    @section.next_document.title.must_equal @section2.title

  end

  it 'can accept insertions of new subdocuments xxx' do

    @section.add_to(@article)
    @section2.add_to(@article)
    @section3.insert(1, @article)


    @article.subdocument(0).title.must_equal @section.title
    @article.subdocument(1).title.must_equal @section3.title
    @article.subdocument(2).title.must_equal @section2.title

    left = @article.subdocument(0)
    middle = @article.subdocument(1)
    right = @article.subdocument(2)

    left.next_document.title = middle.title
    middle.previous_document.title = left.title

    middle.next_document.title = right.title
    right.previous_document.title = middle.title

    # @article.subdocument(0).next_subdocument.title.must_equql @section2.title


  end

  it 'can ask subdocument to reference its parent' do

    @section.add_to(@article)
    @section.parent.title.must_equal @article.title

  end

  it 'can form a list of subdocument titles' do
    @section.add_to(@article)
    @section2.add_to(@article)
    @article.subdocument_titles.must_equal ['Uncertainty Principle', 'Wave-Particle Duality']

  end

  it 'can compile a document' do

    @section.add_to(@article)
    compiled_text = @article.compile
    compiled_text.must_include @article.content
    compiled_text.must_include @section.content

  end

  it 'can compile a document to deeper levels using recursion cccc' do

    @section.add_to(@article)
    @section2.add_to(@article)
    @subsection.add_to(@section2)


    puts @section2.subdocument_titles :header
    puts @section2.subdoc_refs


    puts "AAAAA"
    puts @article.subdocument_titles :header
    puts "BBBBB"
    puts @section2.subdocument_titles :header
    puts "CCCCCC"

    compiled_text = @article.compile
    puts

    compiled_text2 = @section2.compile
    compiled_text2.must_include @section2.content
    compiled_text2.must_include @subsection.content
    puts
    


    compiled_text.must_include @article.content
    compiled_text.must_include @section.content
    compiled_text.must_include @section2.content
    compiled_text.must_include @subsection.content

  end


  it 'can report ccc3' do

    @section2.add_to(@article)
    @subsection.add_to(@section2)

    puts '*2*********************************'
    puts @section2.subdocument_titles :header
    puts @section2.subdoc_refs
    puts '*2*********************************'

    puts "@section2: #{@section2.content}"
    puts "@subsection: #{ @subsection.content}"
    compiled =  @article.compile
    puts "compiled: #{compiled}"

    compiled.must_include @section2.content
    compiled.must_include @subsection.content



  end


    it 'can compile a document to deeper levels using recursion ccc2' do

    puts '*2*********************************'
    puts @section2.subdocument_titles :header
    puts @section2.subdoc_refs
    puts '*2*********************************'


    @section.add_to(@article)
    @section2.add_to(@article)
    @section3.add_to(@article)
    @subsection.add_to(@section2)

    puts '*3*********************************'
    puts @section2.subdocument_titles :header
    puts @section2.subdoc_refs
    puts '*3*********************************'



    puts @section2.subdocument_titles :header
    puts @section2.subdoc_refs


    puts

    puts "AAAAA"
    puts @article.subdocument_titles :header
    puts "BBBBB"
    puts @section2.subdocument_titles :header
    puts "CCCCCC"

    compiled_text = @article.compile

    puts

    compiled_text2 = @section2.compile

    compiled_text.must_include @section2.content
    compiled_text.must_include @subsection.content


    compiled_text2.must_include @section2.content
    compiled_text2.must_include @subsection.content

  end

  it 'can form an array of jsonb elements' do
    hash = { texmacros: 555, summary: 434 }
    json_element = JSON.generate hash
    @article.doc_refs = json_element
    element = @article.doc_refs
    hash2 = JSON.parse element
    hash2['texmacros'].must_equal 555
  end

end
