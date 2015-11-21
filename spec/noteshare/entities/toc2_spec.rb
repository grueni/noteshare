require 'spec_helper'

require 'json'

include Noteshare

# The tests below are mainly concerned with
# setting and persisting attributes
describe NSDocument do

  before do

    @hash_array = [{:id=>13246, :title=>"Uncertainty Principle", :identifier=>"317b135f3f878783f1c5", :has_subdocs=>nil}, {:id=>13247, :title=>"Wave-Particle Duality", :identifier=>"8dc3ce7a44896036ffc0", :has_subdocs=>nil}, {:id=>13248, :title=>"Matrix Mechanics", :identifier=>"feede6092947af59e148", :has_subdocs=>false}]

    DocumentRepository.clear

    @toc_array = [{"id"=>2, "title"=>"Uncertainty Principle!", "subdocs"=>false, "identifier"=>"9652dea9d21df0e6108c"}, {"id"=>3, "title"=>"Wave-Particle Duality", "subdocs"=>true, "identifier"=>"82de5e1dcff64e700c2a"}, {"id"=>4, "title"=>"Matrix Mechanics", "subdocs"=>false, "identifier"=>"64ac591f1c838c955a45"}, {"id"=>10, "title"=>"Perturbation theory", "subdocs"=>false, "identifier"=>"4e547e04cd392ecc5a33"}, {"id"=>11, "title"=>"The Scattering Matrix", "subdocs"=>false, "identifier"=>"26212575a47b1063c0ac"}]

    @article = DocumentRepository.create(NSDocument.new(title: 'Quantum Mechanics', author: 'Jared. Foo-Bar'))

    @article.toc = @hash_array


  end


  it 'can return a TOC item given an id' do

    toc = TOC.new(@article)
    hash = @hash_array[0]
    id = hash[:id]
    title = hash[:title]

    item =toc.get(id)
    item.title.must_equal(title)

  end


  it 'can change the the title of a TOC item given an id' do

    toc = TOC.new(@article)
    hash = @hash_array[0]
    id = hash[:id]

    toc.change_title(id, 'Foo')
    toc.get_title(id).must_equal('Foo')

  end

  it 'can intitialize itself from hash' do

  end



end


