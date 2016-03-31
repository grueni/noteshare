require 'spec_helper'

require 'json'



describe NSDocument do

  before 'set up a root document with subdocuments' do

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

  end


  describe 'initialization' do

    it 'can be initialised with attributes, with defaults set' do
      document = NSDocument.new(title: 'Quantum Mechanics', author: 'J.L Foo-Bar')
      document.title.must_equal 'Quantum Mechanics'
      empty_hash = {}
      document.doc_refs.must_equal empty_hash
      document.subdoc_refs.must_equal []
    end

    it 'can save data and later retrieve it by title' do
      doc = DocumentRepository.first
      title = doc.title
      doc2 = DocumentRepository.find_one_by_title(title)
      doc2.title.must_equal title

      article = DocumentRepository.find_one_by_title 'Quantum Mechanics'
      article.title.must_equal 'Quantum Mechanics'

    end

  end

  describe 'subdoc_refs (to deprecate)' do

    it 'persists subdoc_refs pppe' do
      title =  'Quantum Mechanics'
      doc = DocumentRepository.find_one_by_title(title)
      doc.subdoc_refs = [1,2,3]
      DocumentRepository.update doc
      doc2 = DocumentRepository.find_one_by_title(title)
      doc2.title.must_equal title
      doc2.subdoc_refs.must_equal [1,2,3]
    end

  end

  #########################################################################

  describe 'building a root document' do


    it 'can be done by making insertions' do


      @section1.insert(0,@article)
      @section2.insert(1,@article)
      @section3.insert(1, @article)

      @article.subdocument(0).title.must_equal @section1.title
      @article.subdocument(1).title.must_equal @section3.title
      @article.subdocument(2).title.must_equal @section2.title

    end

    it 'constructs a TOC to manage navigation to previous and next documents' do

      @section1.insert(0,@article)
      @section2.insert(1,@article)
      @section3.insert(1, @article)

      left = @article.subdocument(0)
      middle = @article.subdocument(1)
      right = @article.subdocument(2)

      left.next_document.title.must_equal middle.title
      middle.previous_document.title.must_equal left.title

      middle.next_document.title.must_equal right.title
      right.previous_document.title.must_equal middle.title

      @article.subdocument(0).next_document.title.must_equal @article.subdocument(1).title
      @article.subdocument(1).previous_document.title.must_equal @article.subdocument(0).title


    end

    it 'creates the correct references to the parent document' do

      @section1.add_to(@article)
      @section2.add_to(@article)
      @section3.add_to(@article)

      @section1.parent_document.title.must_equal @article.title
      @article.subdocument(0).title.must_equal @section1.title
      @section1.parent_id.must_equal @article.id

      @section1.index_in_parent.must_equal 0
      @section2.index_in_parent.must_equal 1

      @section1.parent_document.title.must_equal @article.title

    end


    it 'can make a document be the child of its (upper) siblingr sxx' do


      @section1.add_to(@article)
      @section2.add_to(@article)
      @section3.add_to(@article)
      @subsection.add_to(@article)



      id = @article.id

      @tocManager = TOCManager.new(@subsection)
      @tocManager.make_child_of_sibling

      @article = DocumentRepository.find id

      assert @subsection.parent_document == @section3

    end

    it 'can make a document which was the child of its parent be the sibling of its parent sss' do

      id = @article.id

      @section1.add_to(@article)
      @section2.add_to(@article)
      @section3.add_to(@article)
      @subsection.add_to(@section3)

      @toc_manager = TOCManager.new(@subsection)
      @toc_manager.move_section_to_sibling_of_parent
      # @subsection.move_section_to_sibling_of_parent

      @article = DocumentRepository.find id

      assert @subsection.previous_document == @section3

    end

  end


  #########################################################################


  describe 'references to the parent and root document' do

    it 'are set up by the "insert" method 888  ' do

      @section1.insert(0,@article)
      @section2.insert(1,@article)
      @section3.insert(2,@article)
      @subsection.insert(0, @section3)
      @subsubsection.insert(0, @subsection)

      @article.root_document_id.must_equal 0
      @section1.root_document_id.must_equal @article.id
      @subsection.root_document_id.must_equal @article.id
      @subsubsection.root_document_id.must_equal @article.id

    end

    it 'manages the root_document pointer' do

      @section1.add_to(@article)
      @section2.add_to(@article)
      @section3.add_to(@article)
      @subsection.add_to(@section2)
      @subsubsection.add_to(@subsection)

      @article.root_document_id.must_equal 0
      @section1.root_document_id.must_equal @article.id
      @subsection.root_document_id.must_equal @article.id
      @subsubsection.root_document_id.must_equal @article.id

    end

    it 'can find the root document of any document' do

      @section1.add_to(@article)
      @section2.add_to(@article)
      @section3.add_to(@article)
      @subsection.add_to(@section2)
      @subsubsection.add_to(@subsection)


      @article.root_document.must_equal @article
      @section1.root_document.must_equal @article
      @subsection.root_document.must_equal @article
      @subsubsection.root_document.must_equal @article


    end

    it 'can find the next oldest ancestor noa' do

      @section1.add_to(@article)
      @section2.add_to(@article)
      @section3.add_to(@article)
      @subsection.add_to(@section2)
      @subsubsection.add_to(@subsection)

      @section2.next_oldest_ancestor.must_equal @section2
      @subsection.next_oldest_ancestor.must_equal @section2
      @subsubsection.next_oldest_ancestor.must_equal @section2

    end

    it 'can computpute the level of a document' do

      @section1.content = 'Foo'
      @section1.asciidoc_level.must_equal(0)

      @section1.content = '= Foo'
      @section1.asciidoc_level.must_equal(0)

      @section1.content = '== Foo'
      @section1.asciidoc_level.must_equal(1)

      @section1.content = '=== Foo'
      @section1.asciidoc_level.must_equal(2)

    end




  end


  #########################################################################

  describe 'deletions: ' do

    it 'subdocuments can detached from their parent 666' do

      @section1.add_to(@article)
      @section2.add_to(@article)
      @section3.add_to(@article)

      @section2.remove_from_parent

      p = @section1.parent_document

      p.subdocument(0).next_document.title.must_equal p.subdocument(1).title
      p.subdocument(1).previous_document.title.must_equal p.subdocument(0).title

    end

    it 'subocuments can be deleted, with associated structures cleaned up 666'  do

      @section1.add_to(@article)
      @section2.add_to(@article)
      @section3.add_to(@article)

      p = @section1.parent_document

      #  @section2.delete

      p = DocumentRepository.find p.id

      #      p.subdocument(0).next_document.title.must_equal p.subdocument(1).title
      p.subdocument(1).previous_document.title.must_equal p.subdocument(0).title

    end


    it 'subdocuments can be removed from their parent uuu'  do

      @section1.add_to(@article)
      @section2.add_to(@article)
      @section3.add_to(@article)


      p = @section1.parent_document
      p_id = p.id

      @section2.remove_from_parent

      p = DocumentRepository.find p_id

      assert p.toc.count == 2

    end

  end

  describe 'moves mxx' do


    it 'can compute the grandparent' do

      @section1.add_to(@article)
      @section2.add_to(@section1)
      @section3.add_to(@section2)

      assert @section2.grandparent_document == @article
      assert @section1.grandparent_document == nil

    end

    it 'can remove a document from its parent rxx' do


      @section1.add_to(@article)
      @section2.add_to(@article)
      @section3.add_to(@article)

      assert @article.toc.count == 3

      @section2.remove_from_parent

      # reload
      @article = DocumentRepository.find @article.id
      @article.toc.count.must_equal(2)

    end


    it 'can move a subdocument up one level step-by-step msup' do


      id = @article.id

      @section1.add_to(@article)
      @section2.add_to(@article)
      @section3.add_to(@article)
      @subsection.add_to(@section2)

      assert @section2.toc.count == 1, '@section2 has ons subdocument'

      @subsection.remove_from_parent

      @section2 = DocumentRepository.find @section2.id
      assert @section2.toc.count == 0, 'after removal, @section2 has no subdocuments'

      @subsection = DocumentRepository.find @subsection.id
      @subsection.add_to(@article)

      @article = DocumentRepository.find id

      assert @article.toc.count == 4

    end


    it 'can move a subdocument up one level mup' do

      parid = @article.id
      subid = @subsection.id

      @section1.add_to(@article)
      @section2.add_to(@article)
      @section3.add_to(@article)
      @subsection.add_to(@section2)

      @subsection.add_to(@section2)

      @tocManager = TOCManager.new(@subsection)
      @tocManager.move_section_to_parent_level

      @article = DocumentRepository.find parid
      @subsection = DocumentRepository.find subid

      assert @subsection.parent_document == @article

      assert @article.toc.count == 4
      assert @article.subdocument(3) == @subsection
    end


    it 'can move a subdocument from one position to another mmm' do

      @section1.add_to(@article)
      @section2.add_to(@article)
      @section3.add_to(@article)

      t1 = @section1.title
      t2 = @section2.title
      t3 = @section3.title

      @section1.move_to(2)
      #Fixme

      @article = DocumentRepository.find @article.id

      @article.subdocument(2).title.must_equal(t1)

    end

  end

  #########################################################################

  describe 'compilation' do


    it 'can compile a simple document' do

      @user = User.create(first_name: 'Curtis', last_name: 'Corto', screen_name: 'cc', password:'foobar123', password_confirmation:'foobar123')
      @document = NSDocument.create(title: 'Compendium Vitae', author_credentials: @user.credentials)
      @document.content = ""
      @document.compile

    end


    it 'iterates over subdocuments' do
      @section1.add_to(@article)
      compiled_text = @article.compile
      compiled_text.must_include @article.content
      compiled_text.must_include @section1.content
    end

    it 'descends to arbitrarily deep levels using recursion' do
      @section1.add_to(@article)
      @section2.add_to(@article)
      @subsection.add_to(@section2)

      compiled_text = @article.compile

      compiled_text2 = @section2.compile
      compiled_text2.must_include @section2.content
      compiled_text2.must_include @subsection.content

      compiled_text.must_include @article.content
      compiled_text.must_include @section1.content
      compiled_text.must_include @section2.content
      compiled_text.must_include @subsection.content

    end

    it 'descends to arbitrarily deep levels using recursion (second test)' do

      @section2.add_to(@article)
      @subsection.add_to(@section2)
      compiled =  @article.compile

      compiled.must_include @section2.content
      compiled.must_include @subsection.content

    end


    it 'descends to arbitrarily deep levels using recursion (third test)' do

      @section1.add_to(@article)
      @section2.add_to(@article)
      @section3.add_to(@article)
      @subsection.add_to(@section2)
      @subsubsection.add_to(@subsection)



      text = <<EOF
Quantum phenomena are weird!

The Uncertainty Principle invalidates the notion of trajectory

It is, like, _so_ weird!

He was a count.

Yay!





Its all about the eigenvalues
EOF

      assert @article.compile =~ /crazy/

    end


  end

  #########################################################################


  describe 'associated documents' do

     it 'can be defined directly by setting the doc_refs hash' do

       hash = { texmacros: 555, summary: 434 }
       json_element = JSON.generate hash
       @article.doc_refs = json_element
       element = @article.doc_refs
       hash2 = JSON.parse element
       hash2['texmacros'].must_equal 555

     end

     it 'can be via a hash' do

       @article.doc_refs = {}
       @article.doc_refs['foo'] = 'bar'
       @article.doc_refs['foo'].must_equal 'bar'

     end

     it 'can be defined by the "associate_to" method' do

       @section1.associate_to(@article, 'summary')
       assert @article.associated_document('summary') == @section1
       assert @section1.type == 'associated:summary'

       @section1.parent_id.must_equal(@article.id)
       @section1.parent_item.title.must_equal(@article.title)
       @section1.parent_item.id.must_equal(@article.id)
       @section1.parent_item.identifier.must_equal(@article.identifier)

       @section1.root_document_id.must_equal(@article.id)
       @section1.root_item.title.must_equal(@article.title)
       @section1.root_item.id.must_equal(@article.id)
       @section1.root_item.identifier.must_equal(@article.identifier)

     end

    it 'can be added and deleted, cleaning up after themselves' do
      @section1.associate_to(@article, 'summary')
      @section1.disassociate
      @article = DocumentRepository.find @article.id
      @article.associates.must_equal({})
    end

    it 'can be recognized' do
      @section1.associate_to(@article, 'summary')
      @section1.is_associated_document?.must_equal(true)
      @article.is_associated_document?.must_equal(false)

    end

    it 'can add an associated document from a text string addass' do

      @section1.add_associate(title: 'test', type: 'note', content: 'This is a test.')
      puts @section1.doc_refs
      note = @section1.associated_document('note')
      note.content.must_equal('This is a test.')


    end

   end

  #########################################################################

  describe 'permissions' do

     it 'can be set using the "set_permissions" method' do


       @article.acl_set_permissions('rw', 'r', '-' )
       @article.acl_get(:user).must_equal('rw')
       @article.acl_get(:group).must_equal('r')
       @article.acl_get(:world).must_equal('-')

     end

   end

  #########################################################################

  describe 'application of method to the document tree' do

    it 'can be done using the "apply_to_tree" method acl' do

      @section1.add_to(@article)
      # @section2.add_to(@article)
      # @section3.add_to(@article)

      @article.apply_to_tree(:acl_set_permissions, ['rw', 'r', 'r'])
      @article.acl_get(:user).must_equal('rw')
      @section1 = DocumentRepository.find @section1.id
      @section1.acl_get(:user).must_equal('rw')


    end

    it 'works on subdocuments and associated documents to arbitrary depth' do

      @section1.add_to(@article)
      @subsection.add_to(@section1)
      @section2.associate_to(@section1,'summary')
      @section3.associate_to(@section2, 'notes')

=begin
      @article.apply_to_tree(:set_visibility, [666])
      @article.visibility.must_equal(666)

      @subsection = DocumentRepository.find @subsection.id
      @subsection.visibility.must_equal(666)

      @section2 = DocumentRepository.find @section2.id
      @section2.visibility.must_equal(666)

      @section3 = DocumentRepository.find @section2.id
      @section3.visibility.must_equal(666)

=end
    end


  end


  #########################################################################

  describe 'rendering' do



    it 'sets render_options to { format => adoc} by default roo' do

      hash = { 'format' => 'adoc'}
      @article.render_options.must_equal hash



    end

    it 'can change and persist render_options ro2' do

      @article.render_options['foo'] = 'bar'
      @article.render_options['foo'].must_equal 'bar'
      DocumentRepository.persist(@article)
      @foo = DocumentRepository.find(@article.id)
      @foo.render_options['foo'].must_equal 'bar'


    end


  end



end
