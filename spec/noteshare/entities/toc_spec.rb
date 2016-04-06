require 'spec_helper'

require 'json'

include Noteshare

# The tests below are mainly concerned with
# setting and persisting attributes
describe NSDocument do

  before do


    DocumentRepository.clear

    @toc_array = [{"id"=>2, "title"=>"Uncertainty Principle!", "subdocs"=>false, "identifier"=>"9652dea9d21df0e6108c"}, {"id"=>3, "title"=>"Wave-Particle Duality", "subdocs"=>true, "identifier"=>"82de5e1dcff64e700c2a"}, {"id"=>4, "title"=>"Matrix Mechanics", "subdocs"=>false, "identifier"=>"64ac591f1c838c955a45"}, {"id"=>10, "title"=>"Perturbation theory", "subdocs"=>false, "identifier"=>"4e547e04cd392ecc5a33"}, {"id"=>11, "title"=>"The Scattering Matrix", "subdocs"=>false, "identifier"=>"26212575a47b1063c0ac"}]

    @article = DocumentRepository.create(NSDocument.new(title: 'Quantum Mechanics', author: 'Jared. Foo-Bar'))

    @article.toc = @toc_array

    DocumentRepository.persist @article

    @user = User.create(first_name: 'Jared', last_name: 'Foo-Bar', screen_name: 'jayfoo', password: 'foobar123', password_confirmation: 'foobar123')


    @article1 = NSDocument.create(title: 'Quantum Mechanics', author_credentials: @user.credentials)

    @section1 = NSDocument.create(title: 'Uncertainty Principle', author_credentials: @user.credentials)
    @section2 = NSDocument.create(title: 'Wave-Particle Duality', author_credentials: @user.credentials)
    @section3 = NSDocument.create(title: 'Matrix Mechanics', author_credentials: @user.credentials)
    @subsection1 =  NSDocument.create(title: "de Broglie's idea", author_credentials: @user.credentials)
    @subsection2 =  NSDocument.create(title: "Fourier Integrals", author_credentials: @user.credentials)

    @subsubsection1 =  NSDocument.create(title: "Foo!", author_credentials: @user.credentials)
    @subsubsection2 =  NSDocument.create(title: "Baz", author_credentials: @user.credentials)


    @article1.content = 'Quantum phenomena are weird!'
    @section1.content = 'The Uncertainty Principle invalidates the notion of trajectory'
    @section2.content = 'It is, like, _so_ weird!'
    @section3.content = 'Its all about the eigenvalues'
    @subsection1.content = 'He was a count.'
    @subsubsection1.content = 'Yay!'

    DocumentRepository.update @article1
    DocumentRepository.update @section1
    DocumentRepository.update @section2
    DocumentRepository.update @section3
    DocumentRepository.update @subsection1
    DocumentRepository.update @subsection2
    DocumentRepository.update @subsubsection1
    DocumentRepository.update @subsubsection2

    manager = DocumentManager.new(@article)
    manager.append(@section1)
    manager.append(@section2)
    manager.append(@section3)
    manager2 = DocumentManager.new(@section2)
    manager2.append(@subsection1)
    manager2.append(@subsection2)

  end



  it 'can initialize an instance from a toc_array and access the data therein (weak check)' do

    t = TOC.new(@article)
    t.table[0].id.must_equal @toc_array[0]['id']

  end



  it 'can make changes to its data, read them back, and save them to the database  cxx' do

    t = TOC.new(@article)
    id = @article.id
    t.table[0].id = 777
    t.table[0].id.must_equal 777

    # In this case the changes are not persisted
    a = DocumentRepository.find id
    tt = TOC.new(a)
    assert tt.table[0].id != 777

    # In this case the changes are persisted
    t.save!
    a = DocumentRepository.find id
    tt = TOC.new(a)
    assert tt.table[0].id == 777

  end


  it 'sets the correct parent_item and root_item fields for a document added to another' do

    table = TOC.new(@article1).table
    table.must_equal ([])




    table1 = TOC.new(@article1).table

    DocumentRepository.update @article1

    table2 = TOC.new(@article1).table

    table2.must_equal(table1)
    table2[0].id.must_equal(@section1.id)
    table2[0].title.must_equal(@section1.title)

    @section1.parent_item.identifier.must_equal @article1.identifier

    # @section1.display('@section1', [:id, :title, :identifier, :root_document_id, :root_ref, :root_item, :parent_id, :parent_ref, :parent_item, :toc])
    # @article1.display('@section1', [:id, :title, :identifier, :root_document_id, :root_ref, :root_item, :parent_id, :parent_ref, :parent_item, :toc])

    @section1.parent_item.id.must_equal(@article1.id)
    @section1.parent_id.must_equal(@article1.id)
    @section1.root_item.title.must_equal(@article1.title)
    @section1.level.must_equal(1)
    @section1.ancestor_ids.must_equal([@article1.id])
    # assert @section1.toc[0].identifier != nil


  end



  it 'can update its table of contents mtoc 666' do

    # @article.update_table_of_contents


    table = TOC.new(@article1).table
    table.count.must_equal(3)
    table[2].title.must_equal(@section3.title)

    DocumentRepository.update @article1

    article2 = DocumentRepository.find @article1.id
    article2_table = TOC.new(article2).table

    @section1.previous_document.must_equal(nil)
    @section1.next_document.title.must_equal(@section2.title)

    @section2.previous_document.title.must_equal(@section1.title)
    @section2.next_document.title.must_equal(@section3.title)

    @section3.previous_document.title.must_equal(@section2.title)
    @section3.next_document.must_equal(nil)

    DocumentRepository.update @article1


  end

  it 'can return a TOC item given an id 777' do



    puts "@section2 id = #{@section2.id}".red

    # puts @article1.toc

    toc = TOC.new(@article)
    puts '===================='.red
    puts toc.inspect.red
    toc.display
    puts '===================='.red


    _item = toc.get_by_doc_title @section2.title
    if _item
      puts _item.inspect.cyan
    else
      puts "_item is NIL".red
    end
   #  _item ? puts _item.inspect.cyan : puts "_item is NIL".red
    _item[:title].must_equal(@section2.title)

  end

  it 'can return a TOC item given an id (20' do



  end


  it 'can crudely delete an entry by id number cuu' do


    assert @article1.toc.count == 3,  'There should be three items in the toc after setup'

    p = @section2.parent_document

    assert p == @article1

    _toc = TOC.new(p)
    _toc.delete_by_identifier(@section2.identifier)
    _toc.save!

    assert p.toc.count == 2, 'There should be two items in the toc after removal'

  end

  it 'can delete an entry by id number duu' do

    id = @article1.id

    assert @article1.toc.count == 3,  'There should be three items in the toc after setup'

    @section2.remove_from_parent

    @article2 = DocumentRepository.find id

    assert @article2.toc.count == 2, 'There should be two items in the toc after removal'

  end

  it 'can swap two entries in the TOC (swax)' do

    id = @article1.id

    TOC.new(@article1).swap(@section1, @section3)

    @article1 = DocumentRepository.find id
    assert @article1.subdocument(0) == @section3
    assert @article1.subdocument(2) == @section1


  end

  it 'can swap two entries in the TOC using NSDocument convenience methods(sway)' do

    id = @article1.id

    @tocManager = TOCManager.new(@section1)

    @tocManager.sibling_swap_in_toc(@section3)


    @article1 = DocumentRepository.find id
    assert @article1.subdocument(0) == @section3
    assert @article1.subdocument(2) == @section1


  end

  it 'can move a subdocument up in the toc upx' do

    id = @article1.id

    @tocManager = TOCManager.new(@section3)
    @tocManager.move_up_in_toc

    @article1 = DocumentRepository.find id
    assert @article1.subdocument(1) == @section3
    assert @article1.subdocument(2) == @section2

  end

  it 'can respond gracefully when the section if the first subdocument' do

    id = @article1.id

    @tocManager = TOCManager.new(@section1)
    @tocManager.move_up_in_toc

    @article1 = DocumentRepository.find id
    assert @article1.subdocument(0) == @section1
    assert @article1.subdocument(1) == @section2
    assert @article1.subdocument(2) == @section3


  end

  it 'can move a subdocument down in the toc downx' do

    id = @article1.id

    @tocManager = TOCManager.new(@section1)
    @tocManager.move_down_in_toc

    @article1 = DocumentRepository.find id
    assert @article1.subdocument(0) == @section2
    assert @article1.subdocument(1) == @section1

  end

  it 'can respond gracefully when the section if the last subdocument downxx' do

    id = @article1.id

    @tocManager = TOCManager.new(@section3)
    @tocManager.move_down_in_toc


    @article1 = DocumentRepository.find id
    assert @article1.subdocument(0) == @section1
    assert @article1.subdocument(1) == @section2
    assert @article1.subdocument(2) == @section3


  end



end


