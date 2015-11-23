require 'spec_helper'

require 'json'

describe NSDocument do

  before do

    DocumentRepository.clear


    @user = User.create(first_name: 'Jared', last_name: 'Foo-Bar', screen_name: 'jayfoo', password: 'foobar123', password_confirmation: 'foobar123')
    UserRepository.create(@user)

    @article = NSDocument.create(title: 'Quantum Mechanics', author_credentials: @user.credentials)
    @section = NSDocument.create(title: 'Uncertainty Principle', author_credentials: @user.credentials)
    @section2 = NSDocument.create(title: 'Wave-Particle Duality', author_credentials: @user.credentials)
    @section3 = NSDocument.create(title: 'Matrix Mechanics', author_credentials: @user.credentials)
    @subsection =  NSDocument.create(title: "de Broglie's idea", author_credentials: @user.credentials)


    @article.content = 'Quantum phenomena are weird!'
    @section.content = 'The Uncertainty Principle invalidates the notion of trajectory'
    @section2.content = 'It is, like, _so_ weird!'
    @subsection.content = 'He was a count.'

    DocumentRepository.persist @article
    DocumentRepository.persist @section
    DocumentRepository.persist @section2
    DocumentRepository.persist @section3
    DocumentRepository.persist @subsection

  end

  it 'can run an intiaization script' do

    @article = DocumentRepository.find_one_by_title 'A. Quantum Mechanics'
    @section1 = DocumentRepository.find_one_by_title'S1. Uncertainty Principle'
    @section2 = DocumentRepository.find_one_by_title  'S2. Wave-Particle Duality'
    @section3 = DocumentRepository.find_one_by_title  'S3. Matrix Mechanics'
    @subsection = DocumentRepository.find_one_by_title  "SS. de Broglie"

  end


  ######### next and prev #####



  it 'can accept insertions of new subdocuments aii' do


    @section.insert(0,@article)
    @section2.insert(1,@article)
    @section3.insert(1, @article)

    @article.subdocument(0).title.must_equal @section.title
    @article.subdocument(1).title.must_equal @section3.title
    @article.subdocument(2).title.must_equal @section2.title


    left = @article.subdocument(0)
    middle = @article.subdocument(1)
    right = @article.subdocument(2)

    left.next_document.title.must_equal middle.title
    middle.previous_document.title.must_equal left.title

    middle.next_document.title.must_equal right.title
    right.previous_document.title.must_equal middle.title

    # @article.subdocument(0).next_document.title.must_equal @section1.title

  end

  it 'can ask subdocument to reference its parent' do

    @section.add_to(@article)
    @section.parent_document.title.must_equal @article.title

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

    compiled_text = @article.compile

    compiled_text2 = @section2.compile
    compiled_text2.must_include @section2.content
    compiled_text2.must_include @subsection.content

    compiled_text.must_include @article.content
    compiled_text.must_include @section.content
    compiled_text.must_include @section2.content
    compiled_text.must_include @subsection.content

  end



  it 'can report ccc3' do

    @section2.add_to(@article)
    @subsection.add_to(@section2)

    compiled =  @article.compile

    compiled.must_include @section2.content
    compiled.must_include @subsection.content



  end


    it 'can compile a document to deeper levels using recursion ccc2' do

      @section.add_to(@article)
      @section2.add_to(@article)
      @subsection.add_to(@section2)


    compiled =  @article.compile

    compiled.must_include @section2.content
    compiled.must_include @subsection.content


  end


  it 'can form an array of jsonb elements' do
    hash = { texmacros: 555, summary: 434 }
    json_element = JSON.generate hash
    @article.doc_refs = json_element
    element = @article.doc_refs
    hash2 = JSON.parse element
    hash2['texmacros'].must_equal 555
  end

  it 'can associate one document to another' do


    @section.associate_to(@article, 'summary')
    assert @article.associated_document('summary') == @section
    assert @section.type == 'associated:summary'

    assert @article.get_author_credentials['id'] == @user.id
    assert @article.get_author_credentials['first_name'] == @user.first_name
    assert @article.get_author_credentials['last_name' ] == @user.last_name
    @article.get_author_credentials['identifier'].must_equal(@user.identifier)

    @section.parent_id.must_equal(@article.id)
    @section.parent_item.title.must_equal(@article.title)
    @section.parent_item.id.must_equal(@article.id)
    @section.parent_item.identifier.must_equal(@article.identifier)

    @section.root_document_id.must_equal(@article.id)
    @section.root_item.title.must_equal(@article.title)
    @section.root_item.id.must_equal(@article.id)
    @section.root_item.identifier.must_equal(@article.identifier)

  end

end
