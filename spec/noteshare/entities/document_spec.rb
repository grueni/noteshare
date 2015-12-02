require 'spec_helper'

require 'json'

describe NSDocument do

  before 'set up a root document with subdocuments' do

    DocumentRepository.clear


    @user = User.create(first_name: 'Jared', last_name: 'Foo-Bar', screen_name: 'jayfoo', password: 'foobar123', password_confirmation: 'foobar123')
    UserRepository.create(@user)

    @article = NSDocument.create(title: 'Quantum Mechanics', author_credentials: @user.credentials)
    @section = NSDocument.create(title: 'Uncertainty Principle', author_credentials: @user.credentials)
    @section2 = NSDocument.create(title: 'Wave-Particle Duality', author_credentials: @user.credentials)
    @section3 = NSDocument.create(title: 'Matrix Mechanics', author_credentials: @user.credentials)
    @subsection =  NSDocument.create(title: "de Broglie's idea", author_credentials: @user.credentials)


    @article.content = 'Quantum phenomena are weird!'
    @section.content = 'The Uncertainty Principle invalidates the notion of trajectory'
    @section2.content = 'It is, like, _so_ weird!'
    @subsection.content = 'He was a count.'

    DocumentRepository.persist @article
    DocumentRepository.persist @section
    DocumentRepository.persist @section2
    DocumentRepository.persist @section3
    DocumentRepository.persist @subsection

  end

  it 'can find single documents by title' do

    article = DocumentRepository.find_one_by_title 'Quantum Mechanics'
    article.title.must_equal 'Quantum Mechanics'

  end

  describe 'building a root document' do


    it 'can be done by making insertions' do


      @section.insert(0,@article)
      @section2.insert(1,@article)
      @section3.insert(1, @article)

      @article.subdocument(0).title.must_equal @section.title
      @article.subdocument(1).title.must_equal @section3.title
      @article.subdocument(2).title.must_equal @section2.title

    end

    it 'constructs a TOC to manage navigation to previous and next documents' do

      @section.insert(0,@article)
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

    it 'creates the correct referneces to the parent document' do

      @section.add_to(@article)
      @section.parent_document.title.must_equal @article.title

    end


  end

  describe 'compilation' do

    it 'iterates over subdocuments' do
      @section.add_to(@article)
      compiled_text = @article.compile
      compiled_text.must_include @article.content
      compiled_text.must_include @section.content
    end

    it 'descends to arbitrarily deep levels using recursion' do
      @section.add_to(@article)
      @section2.add_to(@article)
      @subsection.add_to(@section2)

      compiled_text = @article.compile

      compiled_text2 = @section2.compile
      compiled_text2.must_include @section2.content
      compiled_text2.must_include @subsection.content

      compiled_text.must_include @article.content
      compiled_text.must_include @section.content
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


  end


   describe 'associated documents' do

     it 'can be defined directly by setting the doc_refs hash' do

       hash = { texmacros: 555, summary: 434 }
       json_element = JSON.generate hash
       @article.doc_refs = json_element
       element = @article.doc_refs
       hash2 = JSON.parse element
       hash2['texmacros'].must_equal 555

     end

     it 'can be defined by the "associate_to" method' do

       @section.associate_to(@article, 'summary')
       assert @article.associated_document('summary') == @section
       assert @section.type == 'associated:summary'

       assert @article.get_author_credentials['id'] == @user.id
       assert @article.get_author_credentials['first_name'] == @user.first_name
       assert @article.get_author_credentials['last_name' ] == @user.last_name
       @article.get_author_credentials['identifier'].must_equal(@user.identifier)

       @section.parent_id.must_equal(@article.id)
       @section.parent_item.title.must_equal(@article.title)
       @section.parent_item.id.must_equal(@article.id)
       @section.parent_item.identifier.must_equal(@article.identifier)

       @section.root_document_id.must_equal(@article.id)
       @section.root_item.title.must_equal(@article.title)
       @section.root_item.id.must_equal(@article.id)
       @section.root_item.identifier.must_equal(@article.identifier)

     end

   end

   describe 'permissions' do

     it 'can be set using the "set_permissions" method' do


       @article.set_permissions('rw', 'r', '-' )
       @article.get_user_permission.must_equal('rw')
       @article.get_group_permission.must_equal('r')
       @article.get_world_permission.must_equal('-')

     end

   end



  describe 'application of method to the document tree' do

    it 'can be done using the "apply_to_tree" method' do

      @section.add_to(@article)
      # @section2.add_to(@article)
      # @section3.add_to(@article)

      @article.apply_to_tree(:set_permissions, ['rw', 'r', 'r'])
      @article.get_acl.get_user.must_equal('rw')
      @section = @section.reload
      @section.get_acl.get_user.must_equal('rw')


    end

    it 'works on subdocuments and associated documents to arbitrary depth' do

      @section.add_to(@article)
      @subsection.add_to(@section)
      @section2.associate_to(@section,'summary')
      @section3.associate_to(@section2, 'notes')

      @article.apply_to_tree(:set_visibility, [666])
      @article.visibility.must_equal(666)

      @subsection = @subsection.reload
      @subsection.visibility.must_equal(666)

      @section2 = @section2.reload
      @section2.visibility.must_equal(666)

      @section3 = @section2.reload
      @section3.visibility.must_equal(666)


    end


  end



end
