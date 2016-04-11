require 'spec_helper'
require_relative '../../../lib/noteshare/modules/toc'

include Noteshare::Core::Document

describe OuterTableOfContents do

  before do

    DocumentRepository.clear


    @user = User.create(first_name: 'Jared', last_name: 'Foo-Bar', screen_name: 'jayfoo', password: 'foobar123', password_confirmation: 'foobar123')
    UserRepository.create(@user)

    @article = NSDocument.create(title: 'Quantum Mechanics', author_credentials: @user.credentials)
    @section1 = NSDocument.create(title: 'Uncertainty Principle', author_credentials: @user.credentials)
    @section2 = NSDocument.create(title: 'Wave-Particle Duality', author_credentials: @user.credentials)
    @section3 = NSDocument.create(title: 'Matrix Mechanics', author_credentials: @user.credentials)
    @subsection =  NSDocument.create(title: "de Broglie's idea", author_credentials: @user.credentials)
    @subsubsection =  NSDocument.create(title: "Wild idea", author_credentials: @user.credentials)


    @article.content = 'Quantum phenomena are weird!'
    @section1.content = 'The Uncertainty Principle invalidates the notion of trajectory'
    @section2.content = 'It is, like, _so_ weird!'
    @subsection.content = 'He was a count.'
    @subsubsection.content = 'This is crazy!'

    DocumentRepository.update @article
    DocumentRepository.update @section1
    DocumentRepository.update @section2
    DocumentRepository.update @section3
    DocumentRepository.update @subsection
    DocumentRepository.update @subsubsection

    dm = DocumentManager.new(@article)
    dm.append(@section1)
    dm.append(@section2)
    dm.append(@section3)



  end

  it 'can be initialized from a document' do

    otc = OuterTableOfContents.new(@article, [], {})
    assert otc.is_a? OuterTableOfContents


  end

  it 'can make the outer leaves of a table of contents' do

    otc = OuterTableOfContents.new(@article, ['dumb'], {})
    output = otc.master_table_of_contents
    expected_output = <<EOF
<ul class='toc2'>
<li>Uncertainty Principle</li>
<li>Wave-Particle Duality</li>
<li>Matrix Mechanics</li>
</ul>
EOF

    output.strip.must_equal expected_output.strip, 'produces html table of contents'


  end


  it 'can dive deeper' do

    dm2 = DocumentManager.new(@section2)
    dm2.append(@subsection)
    dm2.append(@subsubsection)

    otc = OuterTableOfContents.new(@article, ['dumb'], {})
    output = otc.master_table_of_contents

    expected_output = <<EOF
<ul class='toc2'>
<li>Uncertainty Principle</li>
<li>Wave-Particle Duality</li>

<ul class='toc2'>
<li>de Broglie's idea</li>
<li>Wild idea</li>
</ul>


<li>Matrix Mechanics</li>
</ul>
EOF

    assert output.strip.must_equal expected_output.strip


  end

  it 'can produce a table of contents in dragula form' do

    tc = OuterTableOfContents.new(@article, [], {})
    # assert otc.is_a? OuterTableOfContents


  end



end