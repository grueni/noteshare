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

  end

=begin

  it 'can initialize an instance from a toc_array and access the data therein' do

    t = TOC.new(@article)
    t.table[0].id.must_equal @toc_array[0]['id']
    puts "(1)"
    puts t.table
    puts "---------------"



  end



  it 'can make changes to its data and read them back' do

    t = TOC.new(@article)
    t.table[0].id = 777
    t.table[0].id.must_equal 777

  end


  it 'can make changes to its data, persist them, and read them back' do

    article2 = DocumentRepository.find @article.id

    article2.title.must_equal @article.title
    t2 = TOC.new(article2)
    t2.table[0].id.must_equal 2
    t2.table[0].id = 777

    t2.save!

    puts "(2)"
    puts t2.table
    puts "---------------"

    article3 = DocumentRepository.find @article.id
    t3 = TOC.new(article3)
    t3.table[0].id.must_equal 777

  end
=end




  it 'sets the correct parent_item and root_item fields for a document added to another' do

    table = TOC.new(@article1).table
    table.must_equal ([])


    @section1.add_to(@article1)

    table1 = TOC.new(@article1).table

    DocumentRepository.update @article1

    table2 = TOC.new(@article1).table

    table2.must_equal(table1)
    table2[0].id.must_equal(@section1.id)
    table2[0].title.must_equal(@section1.title)

    @section1.parent_item.identifier.must_equal @article1.identifier

    @section1.display('@section1', [:id, :title, :identifier, :root_document_id, :root_ref, :root_item, :parent_id, :parent_ref, :parent_item, :toc])
    @article1.display('@section1', [:id, :title, :identifier, :root_document_id, :root_ref, :root_item, :parent_id, :parent_ref, :parent_item, :toc])


    puts "For #{@section1.title} @section1.parent_item = #{ @section1.parent_item}".red
    @section1.parent_item.id.must_equal(@article1.id)
    @section1.parent_id.must_equal(@article1.id)
    @section1.root_item.title.must_equal(@article1.title)
    @section1.level.must_equal(1)
    @section1.ancestor_ids.must_equal([@article1.id])
    # assert @section1.toc[0].identifier != nil




  end



  it 'can update its table of contents mtoc' do

    # @article.update_table_of_contents

    @section1.add_to(@article1)
    @section2.add_to(@article1)
    @section3.add_to(@article1)
    @subsection1.add_to(@section2)
    @subsection2.add_to(@section2)


    table = TOC.new(@article1).table
    table.count.must_equal(3)
    table[2].title.must_equal(@section3.title)

    DocumentRepository.update @article1


    article2 = DocumentRepository.find @article1.id
    article2_table = TOC.new(article2).table

    @section1.previous_toc_item.must_equal(nil)
    @section1.next_toc_item.title.must_equal(@section2.title)

    @section2.previous_toc_item.title.must_equal(@section1.title)
    @section2.next_toc_item.title.must_equal(@section3.title)

    @section3.previous_toc_item.title.must_equal(@section2.title)
    @section3.next_toc_item.must_equal(nil)

    DocumentRepository.update @article1


  end

  it 'can return a TOC item given an id' do

    @section1.add_to(@article1)
    @section2.add_to(@article1)
    @section3.add_to(@article1)
    @subsection1.add_to(@section2)
    @subsection2.add_to(@section2)


    puts "ITEM 1 #{@article1.toc_item(@section1.id)}".red
    puts "ITEM 2 #{@article1.toc_item(@section2.id)}".red
    puts "ITEM 3 #{@article1.toc_item(@section3.id)}".red
    puts "SUB ITEM 1 #{@article1.toc_item(@subsection1.id)}".red

    item = @article1.toc_item(@section2.id)
    item[:title].must_equal(@section2.title)

  end

  it 'can return a TOC item given an id (20' do

    @section1.add_to(@article1)
    @section2.add_to(@article1)
    @section3.add_to(@article1)
    @subsection1.add_to(@section2)
    @subsection2.add_to(@section2)



  end

  it 'can change the the title of a TOC item given an id' do

    @section1.add_to(@article1)
    @section2.add_to(@article1)
    @section3.add_to(@article1)
    @subsection1.add_to(@section2)
    @subsection2.add_to(@section2)

    puts
    puts "ITEM 2, original: #{@article1.toc_item(@section2.id)}".red

    item = @article1.toc_item_change_title(@section2.id, 'Foo')

    puts "changed item: #{item}".magenta
    puts "NOW TOC IS: #{@article1.toc}".cyan

    item[:title].must_equal('Foo')

    item2 = @article1.toc_item(@section2.id)
    item2[:title].must_equal('Foo')

  end

  it 'can delete an entry by id number' do

    @section1.add_to(@article1)
    @section2.add_to(@article1)
    @section3.add_to(@article1)

    @section2.remove_from(@article)

  end


=begin


 it 'can update its table of contents mtoc' do

    # @article.update_table_of_contents

    @section1.add_to(@article1)
    @section2.add_to(@article1)
    # @section3.add_to(@article1)
    # @subsection1.add_to(@section2)
    # @subsection2.add_to(@section2)

    puts "TOC for article:"
    puts @article1.toc

    puts "TOC for first section:"
    puts @section1.toc

    puts "\n\nTOC for second section:"
    puts @section2.toc

    flat_toc = @article1.toc.flatten

    flat_toc[0].title.must_equal 'Uncertainty Principle'
    # flat_toc[1].title.must_equal 'Wave-Particle Duality'
    # flat_toc[5].must_equal 'Matrix Mechanics'


  end

  it 'can construct a master table of contents' do

    @article.update_table_of_contents
    puts @article.master_table_of_contents

  end

  it 'can compute the level of a subdocument xxx' do

    @article.level.must_equal 0
    @section1.level.must_equal 1
    @subsection1.level.must_equal 2

  end

=end

end


