require 'spec_helper'

require 'spec_helper'

describe Document do
  it 'can be initialised with attributes' do
    document = Document.new(title: 'Quantum Mechanics')
    document.title.must_equal 'Quantum Mechanics'
  end
end
