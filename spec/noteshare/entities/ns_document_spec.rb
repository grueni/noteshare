require 'spec_helper'
require 'json'
require 'pry'

include Noteshare::Core::Document

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
    @note =  NSDocument.create(title: "Note", author_credentials: @user.credentials)


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

    manager = DocumentManager.new(@article)
    manager.append(@section1)
    manager.append(@section2)
    manager.append(@section3)
    manager2 = DocumentManager.new(@section3)
    manager2.append(@subsection)
    manager3 = DocumentManager.new(@subsection)
    manager3.append(@subsubsection)

    AssociateDocumentManager.new(@article).attach(@note, 'note')




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

      @article.subdocument(0).title.must_equal @section1.title
      @article.subdocument(1).title.must_equal @section2.title
      @article.subdocument(2).title.must_equal @section3.title

    end

    it 'constructs a TOC to manage navigation to previous and next documents' do


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

      @section1.parent_document.title.must_equal @article.title
      @article.subdocument(0).title.must_equal @section1.title
      @section1.parent_id.must_equal @article.id

      @section1.index_in_parent.must_equal 0
      @section2.index_in_parent.must_equal 1

      @section1.parent_document.title.must_equal @article.title

    end


  end


  #########################################################################


  describe 'references to the parent and root document' do

    it 'are set up by the "insert" method 888  ' do

      @article.root_document_id.must_equal 0
      @section1.root_document_id.must_equal @article.id
      @subsection.root_document_id.must_equal @article.id
      @subsubsection.root_document_id.must_equal @article.id

    end

    it 'manages the root_document pointer' do

      @article.root_document_id.must_equal 0
      @section1.root_document_id.must_equal @article.id
      @subsection.root_document_id.must_equal @article.id
      @subsubsection.root_document_id.must_equal @article.id

    end

    it 'can find the root document of any document' do

      @article.root_document.must_equal @article
      @section1.root_document.must_equal @article
      @subsection.root_document.must_equal @article
      @subsubsection.root_document.must_equal @article


    end

    it 'can find the next oldest ancestor noa' do

      @subsection.next_oldest_ancestor.must_equal @section3
      @subsubsection.next_oldest_ancestor.must_equal @section3

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


      @section2.remove_from_parent

      p = @section1.parent_document

      p.subdocument(0).next_document.title.must_equal p.subdocument(1).title
      p.subdocument(1).previous_document.title.must_equal p.subdocument(0).title

    end

    it 'subocuments can be deleted, with associated structures cleaned up 666'  do


      p = @section1.parent_document

      #  @section2.delete

      p = DocumentRepository.find p.id

      #      p.subdocument(0).next_document.title.must_equal p.subdocument(1).title
      p.subdocument(1).previous_document.title.must_equal p.subdocument(0).title

    end


    it 'subdocuments can be removed from their parent uuu'  do

      p = @section1.parent_document
      p_id = p.id

      @section2.remove_from_parent

      p = DocumentRepository.find p_id

      assert p.toc.count == 2

    end

    it 'can delete a root docuemnt and all of its subdocuments and and associated documents rxx' do

      DocumentRepository.all.count.must_equal 7
      @article.delete_root_document
      d = DocumentRepository.all.first
      DocumentRepository.all.count.must_equal 0

    end

  end

  describe 'moves mxx' do


    it 'can compute the grandparent' do

      assert @subsection.grandparent_document == @article
      assert @section1.grandparent_document == nil

    end

    it 'can remove a document from its parent pxx' do

      assert @article.toc.count == 3

      @section2.remove_from_parent

      # reload
      @article = DocumentRepository.find @article.id
      @article.toc.count.must_equal(2)

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

      compiled_text = @article.compile
      compiled_text.must_include @article.content
      compiled_text.must_include @section1.content
    end

    it 'descends to arbitrarily deep levels using recursion cxxx' do



      compiled_text = @article.compile

      compiled_text.must_include @article.content
      compiled_text.must_include @section1.content
      compiled_text.must_include @section2.content
      compiled_text.must_include @subsection.content
      compiled_text.must_include @subsubsection.content

    end

    it 'descends to arbitrarily deep levels using recursion (second test)' do


      compiled =  @article.compile

      compiled.must_include @section2.content
      compiled.must_include @subsection.content

    end


  end


  #########################################################################



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

      @article.apply_to_tree(:acl_set_permissions, ['rw', 'r', 'r'])
      @article.acl_get(:user).must_equal('rw')
      @section1 = DocumentRepository.find @section1.id
      @section1.acl_get(:user).must_equal('rw')


    end


  end


  #########################################################################



end
