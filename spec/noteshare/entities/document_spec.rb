require 'spec_helper'

require 'spec_helper'

describe Document do
  it 'can be initialised with attributes' do
    book = Document.new(title: 'Quantum Mechanics')
    book.title.must_equal 'Quantum Mechanics'
  end
end
