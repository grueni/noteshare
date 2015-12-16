require 'spec_helper'
include Noteshare

describe TOC do


  before do


    DocumentRepository.clear

    @author_credentials = { id: 0, first_name: 'Linus', last_name: 'Pauling', identifier: 'abcd1234'}

    @article = NSDocument.create(title: 'A. Quantum Mechanics', author_credentials: @author_credentials)


    @section1 = NSDocument.create(title: 'S1. Uncertainty Principle', author_credentials: @author_credentials)
    @section2 = NSDocument.create(title: 'S2. Wave-Particle Duality', author_credentials: @author_credentials)
    @section3 = NSDocument.create(title: 'S3. Matrix Mechanics', author_credentials: @author_credentials)
    @subsection =  NSDocument.create(title: "SS. de Broglie", author_credentials: @author_credentials)

    @article.content = 'Quantum phenomena are weird!'
    @section1.content = 'The Uncertainty Principle invalidates the notion of trajectory'
    @section2.content = 'It is, like, _so_ weird!'
    @subsection.content = 'He was a count.'

    DocumentRepository.persist @article
    DocumentRepository.persist @section1
    DocumentRepository.persist @section2
    DocumentRepository.persist @section3
    DocumentRepository.persist @subsection

  end



  it 'can initialize a document' do


    @article = DocumentRepository.create(NSDocument.new(title: 'Quantum Mechanics', author_credentials: @author_credentials))
    @article.title.must_equal('Quantum Mechanics')


  end



  it 'can be initialized from an NSDocument and then the raw data is []' do


    @section1.add_to(@article)
    @section2.add_to(@article)
    @section3.add_to(@article)

  end


  it 'can compile a document to deeper levels using recursion cccc' do

    @section1.add_to(@article)
    @section2.add_to(@article)
    # @subsection.add_to(@section2)
    @section3.add_to(@article)

    compiled_text = @article.compile


    #compiled_text2 = @section2.compile
    #compiled_text2.must_include @section2.content
    # compiled_text2.must_include @subsection.content

    compiled_text.must_include @article.content
    compiled_text.must_include @section1.content
    compiled_text.must_include @section2.content
    # compiled_text.must_include @subsection.content

  end



end
