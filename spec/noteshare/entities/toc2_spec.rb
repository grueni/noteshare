require 'spec_helper'

require 'json'

include Noteshare

# The tests below are mainly concerned with
# setting and persisting attributes
describe NSDocument do

  before do

    @hash = [{:id=>13246, :title=>"Uncertainty Principle", :identifier=>"317b135f3f878783f1c5", :has_subdocs=>nil}, {:id=>13247, :title=>"Wave-Particle Duality", :identifier=>"8dc3ce7a44896036ffc0", :has_subdocs=>nil}, {:id=>13248, :title=>"Matrix Mechanics", :identifier=>"feede6092947af59e148", :has_subdocs=>false}]

    DocumentRepository.clear

    @toc_array = [{"id"=>2, "title"=>"Uncertainty Principle!", "subdocs"=>false, "identifier"=>"9652dea9d21df0e6108c"}, {"id"=>3, "title"=>"Wave-Particle Duality", "subdocs"=>true, "identifier"=>"82de5e1dcff64e700c2a"}, {"id"=>4, "title"=>"Matrix Mechanics", "subdocs"=>false, "identifier"=>"64ac591f1c838c955a45"}, {"id"=>10, "title"=>"Perturbation theory", "subdocs"=>false, "identifier"=>"4e547e04cd392ecc5a33"}, {"id"=>11, "title"=>"The Scattering Matrix", "subdocs"=>false, "identifier"=>"26212575a47b1063c0ac"}]

    @article = DocumentRepository.create(NSDocument.new(title: 'Quantum Mechanics', author: 'Jared. Foo-Bar'))

    @article.toc = @toc_array

    DocumentRepository.persist @article

    @user = User.create(first_name:'Jared', last_name: 'Foo-Bar')


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

    @section1.add_to(@article1)
    @section2.add_to(@article1)
    @section3.add_to(@article1)
    @subsection1.add_to(@section2)
    @subsection2.add_to(@section2)


  end




  it 'sets the correct parent_item and root_item fields for a document added to another' do


    DocumentRepository.update @article1

    table2 = TOC.new(@article1).table

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


    table = TOC.new(@article1).table
    table.count.must_equal(3)
    table[2].title.must_equal(@section3.title)

    DocumentRepository.update @article1

    article2 = DocumentRepository.find @article1.id

    @section1.previous_toc_item.must_equal(nil)
    @section1.next_toc_item.title.must_equal(@section2.title)

    @section2.previous_toc_item.title.must_equal(@section1.title)
    @section2.next_toc_item.title.must_equal(@section3.title)

    @section3.previous_toc_item.title.must_equal(@section2.title)
    @section3.next_toc_item.must_equal(nil)

    DocumentRepository.update @article1

  end

  it 'can return a TOC item given an id' do


    puts "ITEM 1 #{@article1.toc_item(@section1.id)}".red
    puts "ITEM 2 #{@article1.toc_item(@section2.id)}".red
    puts "ITEM 3 #{@article1.toc_item(@section3.id)}".red
    puts "SUB ITEM 1 #{@article1.toc_item(@subsection1.id)}".red

    item = @article1.toc_item(@section2.id)
    item[:title].must_equal(@section2.title)

  end

  it 'can return a TOC item given an id (2)' do

    toc = TOC.new(@article1)
    item =toc.get(@section2.id)
    puts "ITEMMMM: #{item}".red
    puts @article1.toc.to_s
    puts '----------------------'
  end

  it 'can change the the title of a TOC item given an id' do

    puts
    puts "ITEM 2, original: #{@article1.toc_item(@section2.id)}".red

    item = @article1.toc_item_change_title(@section2.id, 'Foo')

    puts "changed item: #{item}".magenta
    puts "NOW TOC IS: #{@article1.toc}".cyan

    item[:title].must_equal('Foo')

    item2 = @article1.toc_item(@section2.id)
    item2[:title].must_equal('Foo')

  end

  it 'can intitialize itself from hash' do

  end

end


