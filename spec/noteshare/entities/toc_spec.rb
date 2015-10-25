require 'spec_helper'

require 'spec_helper'

require 'json'

# The tests below are mainly concerned with
# setting and persisting attributes
describe NSDocument do

  before do

    DocumentRepository.clear

    @article = DocumentRepository.create(NSDocument.new(title: 'Quantum Mechanics', author: 'Jared. Foo-Bar'))
    @section1 = DocumentRepository.create(NSDocument.new(title: 'Uncertainty Principle', author: 'Jared Foo-Bar', subdoc_refs: []))
    @section2 = DocumentRepository.create(NSDocument.new(title: 'Wave-Particle Duality', author: 'Jared Foo-Bar', subdoc_refs: []))
    @section3 = DocumentRepository.create(NSDocument.new(title: 'Matrix Mechanics', author: 'Jared Foo-Bar', subdoc_refs: []))
    @subsection1 =  DocumentRepository.create(NSDocument.new(title: "de Broglie's idea", author: 'Jared Foo-Bar', subdoc_refs: []))
    @subsection2 =  DocumentRepository.create(NSDocument.new(title: "Fourier Integrals", author: 'Jared Foo-Bar', subdoc_refs: []))

    @subsubsection1 =  DocumentRepository.create(NSDocument.new(title: "Foo!", author: 'Jared Foo-Bar', subdoc_refs: []))
    @subsubsection2 =  DocumentRepository.create(NSDocument.new(title: "Baz", author: 'Jared Foo-Bar', subdoc_refs: []))


    @article.content = 'Quantum phenomena are weird!'
    @section1.content = 'The Uncertainty Principle invalidates the notion of trajectory'
    @section2.content = 'It is, like, _so_ weird!'
    @section3.content = 'Its all about the eigenvalues'
    @subsection1.content = 'He was a count.'
    @subsubsection1.content = 'Yay!'

    DocumentRepository.persist @article
    DocumentRepository.persist @section1
    DocumentRepository.persist @section2
    DocumentRepository.persist @section3
    DocumentRepository.persist @subsection1
    DocumentRepository.persist @subsection2
    DocumentRepository.persist @subsubsection1
    DocumentRepository.persist @subsubsection2

  end

  it 'can update its table of contents mtoc' do

    @section1.add_to(@article)
    @section2.add_to(@article)
    @section3.add_to(@article)

    @article.update_table_of_contents

    flat_toc = @article.toc.flatten

    flat_toc[1].must_equal 'Uncertainty Principle'
    flat_toc[3].must_equal 'Wave-Particle Duality'
    flat_toc[5].must_equal 'Matrix Mechanics'


  end

  it 'can construct a master table of contents' do

    @section1.add_to(@article)
    @section2.add_to(@article)
    @section3.add_to(@article)
    @subsection1.add_to(@section2)
    @subsection2.add_to(@section2)
    @subsubsection1.add_to(@subsection1)
    @subsubsection2.add_to(@subsection1)

    @article.update_table_of_contents
    puts @article.master_table_of_contents

  end


end
