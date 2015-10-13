require 'spec_helper'

require 'spec_helper'

describe Document do

  before do
    DocumentRepository.clear

    @article = DocumentRepository.create(Document.new(title: 'Quantum Mechanics', author: 'Jared. Foo-Bar', subdoc_refs: []))
    @section = DocumentRepository.create(Document.new(title: 'Uncertainty Principle', author: 'Jared Foo-Bar', subdoc_refs: []))
    @section2 = DocumentRepository.create(Document.new(title: 'Wave-Particle Duality', author: 'Jared Foo-Bar', subdoc_refs: []))
    @subsection =  DocumentRepository.create(Document.new(title: "de Broglie's idea", author: 'Jared Foo-Bar', subdoc_refs: []))

    @article.content = 'Quantum phenomena are weird!'
    @section.content = 'The Uncertainty Principle invalidates the notion of trajectory'
    @section2.content = 'It is, like, _so_ weird!'
    @subsection.content = 'He was a count.'

    DocumentRepository.persist @article
    DocumentRepository.persist @section
    DocumentRepository.persist @section2
    DocumentRepository.persist @subsection

  end

  it 'can be initialised with attributes' do
    document = Document.new(title: 'Quantum Mechanics')
    document.title.must_equal 'Quantum Mechanics'
  end


  it 'can add subdocuments to a document, setting up refs from parent to child and vice versa' do

    @section.add_to(@article)
    @article.subdocument(0).title.must_equal @section.title
    @section.parent_id.must_equal @article.id

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

  it 'can compile a document to deeper levels' do

    @section.add_to(@article)
    @section2.add_to(@article)
    @subsection.add_to(@section2)
    compiled_text = @article.compile
    compiled_text.must_include @article.content
    compiled_text.must_include @section.content
    compiled_text.must_include @section2.content
    compiled_text.must_include @subsection.content

  end

end
