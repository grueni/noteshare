require 'spec_helper'

require 'spec_helper'

describe Document do

  before do
    DocumentRepository.clear

    @article = DocumentRepository.create(Document.new(title: 'Quantum Mechanics', author: 'Jared. Foo-Bar', part: []))
    @section = DocumentRepository.create(Document.new(title: 'Uncertainty Principle', author: 'Jared Foo-Bar', part: []))

  end

  it 'can be initialised with attributes' do
    document = Document.new(title: 'Quantum Mechanics')
    document.title.must_equal 'Quantum Mechanics'
  end


  it 'can add parts to a document' do

    @section.add_to(@article)
    @article.subdocument(0).title.must_equal @section.title

  end
end
