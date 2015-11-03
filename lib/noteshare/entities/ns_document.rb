require_relative '../../ext/core'
# require_relative '../modules/render'


# An instance of the Document class has *content*, a block of text,
# various metadata -- *title*, *author*, *tags* etc. -- and a set
# of links.  First, there is *subdoc_refs*, an array of *id's*
# of Documents.  The idea is that the text of document is composed of
# its content plus the content of it subdocuments. Subdocuments
# can have their own subdocuments, and so on. The *compile* method
# assembles the content of a document, its subdocuments, etc.,
# in the proper order.   Second, there is
# *doc_refs*, which is a hash that could look like this:
#
# { 'previous': 124, 'next': 201, 'comments': 444, 'summary': 555 }
#
# The *previous* and *next* keys are used by an editor for navigation.
# Keys like *comment* and *summary* point to little documents that
# may or may not not be compiled into the main text.  There is
# also a set of special pointers, *parent_id* and *index_in_parent*.
# Suppose that document 123 refers to document 555 via the  element
# of index two in its *subdoc_refs* array, e.g.,
#
#    subdoc_refs = [21, 19, 555, 56]
#
# Then the parent_id of document 555 is 123 and the value of
# index_in_parent is 2.
#
# The subdoc array is populated by the method *insert*.
# To illustrate, suppose we have documents @article,
# @section1, @section2, and @section3.  The succession of
# method calls
#
#    @section1.insert(0, @article)
#    @section2.insert(1, @article)
#    @section2.insert(2, @article)
#
# builds up the subdoc array of @article and manages
# the pointers parent_id, index_in_parent, previous
# and next.
#
#    CONTENTS
#
#       1. REQUIRE, INCLUDE, AND INITIALIZE
#
class NSDocument

  ###################################################
  #
  #     CONTENTS
  #
  #     1. REQUIRE, INCLUDE, AND INITIALIZE
  #     2. MANAGE SUBDOCUMENTS
  #     3. ASSOCIATED DOCUMENTS
  #     4. UPDATE, COMPILE & RENDER
  #     5. TABLE OF CONTENTS
  #
  ###################################################

  include Lotus::Entity
  attributes :id, :author, :title, :tags, :type, :area, :meta,
    :created_at, :modified_at, :content, :rendered_content, :compiled_and_rendered_content, :render_options,
    :parent_id, :author_id, :index_in_parent, :root_document_id, :visibility,
    :subdoc_refs,  :doc_refs, :toc, :content_dirty, :compiled_dirty, :toc_dirty

  require_relative '../modules/ns_document_presentation'
  include NSDocument::Presentation

  require_relative '../modules/ns_document_setup'
  include NSDocument::Setup


  # When initializing an NSDocument, ensure that certain fields
  # have a standard non-nil value
  def initialize(hash)

    hash.each { |name, value| instance_variable_set("@#{name}", value) }
    @subdoc_refs = [] if @subdoc_refs.nil?
    @toc ||= []
    @doc_refs = {} if @doc_refs.nil?
    @render_options ||= { 'format'=> 'adoc' }
    @root_document_id ||= 0
    @parent_id ||= 0

    # @toc_dirty ||= true

  end

  ###################################################
  #
  #     2. MANAGE SUBDOCUMENTS
  #
  ###################################################

  # @section(k, @article) makes @section the k-th subdocument
  # of @article.  The subdocuments that were in position
  # k and above are shifted to the right.  This method
  # updates all links: parent, index_in_parent,
  # amd the relevant next and previous links
  def insert(k, parent_document)

    # puts "Insert #{self.id} (#{self.title}) at k = #{k}"

    # Insert the id o the current document (receiver)
    # in the subdoc_refs table of the parent document.
    # Not the index of the id and copy that index
    # into self.index_in_parent.  Thus, at the
    # the end of these operatiopations, the parent
    # refernces the child (the subdocument),
    # and vice vrsa.
    index = parent_document.subdoc_refs || []
    index.insert(k, self.id)
    parent_document.subdoc_refs = index
    self.index_in_parent =  k


    # Set the parent_id and root_document_id
    self.parent_id = parent_document.id
    if parent_document.root_document_id == 0
      self.root_document_id = parent_document.id
    else
      self.root_document_id = parent_document.root_document_id
    end

    # Inherit the render_option from the root document
    root_doc = DocumentRepository.find root_document_id
    if root_doc and root_doc != self
      self.render_options = root_doc.render_options
    end

    # update index_in_parent for subdocuments
    # that were shifted to the right
    # puts "Shifting ..."
    # puts "parent_document.subdoc_refs.tail(k+1): #{parent_document.subdoc_refs.tail(k)}"
    parent_document.subdoc_refs.tail(k).each do |id|
      doc = DocumentRepository.find id
      doc.index_in_parent = doc.index_in_parent + 1
      DocumentRepository.persist(doc )
    end

    DocumentRepository.persist(self)
    DocumentRepository.persist(parent_document)

    update_neighbors

  end

  # Used by #insert to preserve the
  # validity of the previous and next
  # links of subdocuments.
  def update_neighbors
    self.set_previous_doc
    self.set_next_doc

    if previous_document
      previous_document.set_next_doc
    end

    if next_document
      next_document.set_previous_doc
    end
  end


  # @section.add_to(@article) makes @section
  # the last subdocument of @article
  def add_to(parent_document)
    n = parent_document.subdoc_refs.length
    insert(n, parent_document)
  end



  # @foo.remove_from_parent removes
  # @foo as a subdocument of its parent.
  # It oes not delete @foo.
  # Fixme: it is intended tht a document have at most one parent.
  # However, this is not yet enforced.
  def remove_from_parent
    k = index_in_parent
    p = parent
    pd = previous_document
    nd_id = next_document.id
    p.subdoc_refs.delete_at(k)
    DocumentRepository.persist(p)

    # update index_in_parent for subdocuments
    # that were shifted to the left
    # puts "Shifting ..."
    # puts "parent_document.subdoc_refs.tail(k+1): #{parent_document.subdoc_refs.tail(k)}"
    p.subdoc_refs.tail(k-1).each do |id|
      doc = DocumentRepository.find id
      doc.index_in_parent = doc.index_in_parent - 1
      DocumentRepository.persist(doc )
    end

    if pd
      pd.set_next_doc
    end

    nd =  DocumentRepository.find nd_id
    if nd
      nd.set_previous_doc
    end
  end

  # @foo.move_to(7) moves @foo in its
  # parent document to position 7.
  # Subdocuments that were in position 7 and up
  # are moved up.
  def move_to(new_position)
    remove_from_parent
    insert(new_position, parent)
  end

  # Assume that receiver is subdocument k of parent.
  # Return the id of subdocument k - 1 or nil
  def previous_id
    p = parent
    return nil if p == nil
    return nil if index_in_parent == nil
    return nil if index_in_parent-1 < 0
    return p.subdoc_refs[index_in_parent-1]
  end

  # Assume that receiver is subdocument k of parent.
  # Return the id of subdocuemnt k + 1 or nil
  def next_id
    p = parent
    return nil if p == nil
    return nil if index_in_parent == nil
    return nil if index_in_parent+1 > p.subdoc_refs.length
    p.subdoc_refs[index_in_parent+1]
  end

  # Return title and id of NSDocument
  def info
    "#{self.title}:: id: #{self.id}"
  end

  # Return title, id, an ids of previous and next documents
  def status
    "#{self.title}:: id: #{self.id}, parent: #{self.parent.id }, back: #{self.doc_refs['previous']}, next: #{@self.doc_refs['next']}"
  end

  # Return next NSDocument.  That is, if @foo, @bar, and @baz
  # are subcocuments in order of @article, then @bar.next_document = @baz
  def next_document
    DocumentRepository.find next_id
  end


  # Return previous NSDocument.  That is, if @foo, @bar, and @baz
  # are subcocuments in order of @article, then @bar.previous_document = @foo
  def previous_document
    DocumentRepository.find previous_id
  end

  # Use the information in self.parent.subdoc_refs
  # to set the previous document link.  Thus,
  # if @foo and @bar are subdocuments in order
  # of @article, then after the call @bar.set_previous_doc,
  # @bar.previous_doc == @foo.
  def set_previous_doc
    self.doc_refs['previous'] = previous_id
    DocumentRepository.persist(self)
  end

  # Use the information in self.parent.subdoc_refs
  # to set the previous document link.  Thus,
  # if @foo and @bar are subdocuments in order
  # of @article, then after the call @foo.set_next_doc,
  # @foo.next_doc == @bar.
  def set_next_doc
    self.doc_refs['next'] = next_id
    DocumentRepository.persist(self)
  end

  # *doc.parent* returns nil or the parent object
  def parent
    if parent_id and parent_id > 0
      DocumentRepository.find(parent_id)
    end
  end

  def next_oldest_ancestor
    noa = self
    return self if noa == root_document
    while noa.parent != root_document
      noa = noa.parent
    end
    noa
  end


  # *doc.subdocment(k)* returns the k-th
  # subdocument of *doc*
  def subdocument(k)
    DocumentRepository.find(subdoc_refs[k])
  end

  # The root_document is what you get by
  # following parent_document links to their
  # source. If the root_document_id is zero,
  # then the document is a root document.
  # Otherwise, the root_document_id is the
  # id of the root_documment.
  def root_document
    if root_document_id == 0
      return self
    else
      DocumentRepository.find(root_document_id)
    end
  end

  # The level is the length of path from the root
  # to the give node (self)
  def level
    length = 0
    cursor = self
    while cursor.parent
      length += 1
      cursor = cursor.parent
    end
    length
  end


  ###################################################
  #
  #      3. ASSOCIATED DOCUMENTS
  #
  ###################################################

  # @foo.associate('summary', @bar)
  # associats @foo to @bar as a 'summary'.
  # It can be retrieved as @foo.associatd_document('summary')
  def associate_as(type, doc)
    doc.doc_refs[type] = self.id
    self.parent_id = doc.id
    self.root_document_id = doc.id
    DocumentRepository.update(doc)
  end

  # @foo.associatd_document('summary')
  # retrieve the document associated to
  # @foo which is of type 'summary'
  def associated_document(type)
    DocumentRepository.find(self.doc_refs[type])
  end

  ###################################################
  #
  #      4. UPDATE CONTENT, COMPILE & RENDER
  #
  ###################################################

  # If input is nil, render the content
  # and save it in rendered_content.  Otherwise,
  # Replace #content by str, render it
  # and save itl. .
  def update_content(input=nil)

    dirty = self.content_dirty
    dirty = true if dirty.nil?

    if dirty == true
      puts "update_content (dirty), id = #{self.id}, title = #{self.title}".magenta
      if input == nil
        str = self.content || ''
      else
        str = input
        self.content = str
      end
      renderer = Render.new(texmacros + str)
      self.rendered_content = renderer.convert
      self.content_dirty = false
      DocumentRepository.update self
    else
      puts "update_content (clean), id = #{self.id}, title = #{self.title}".blue
    end

  end

  def texmacros
    rd = root_document
    if rd and rd.doc_refs['texmacros']
      macro_text = rd.associated_document('texmacros').content
      macro_text = macro_text.gsub(/^=*= .*$/,'')
      macro_text = "\n\n[env.texmacro]\n--\n#{macro_text}\n--\n\n"
      macro_text
    else
      ''
    end
  end

  # *doc.compile* concatenates the contents
  # of *doc* with the compiled text of
  # each section of *doc*.  The sections
  # array is determined by #part, which is
  # a persistent array of integers which
  # represent the id's of the sections of
  # *doc*.
  def compile_aux
    if subdoc_refs == []
      return content
    else
      text = content + "\n\n" || ''
      subdoc_refs.each do |id|
        section = DocumentRepository.find(id)
        text  << section.compile_aux << "\n\n"
      end
      return text
    end
  end

  def compile
    texmacros + compile_aux
  end



  # NSDocument#render is the sole connection between class NSDocument and
  # module Render.  It updates self.rendered_content by applying
  # Asciidoctor.convert to self.content with the provided options.
  def render

    format = @render_options['format']

    case format
      when 'adoc'
        render_option = {}
      when 'adoc-latex'
        render_option = {backend: 'html5'}
      else
        render_option = {}
    end

    renderer = Render.new(self.compile, render_option )
    self.rendered_content = renderer.convert
    DocumentRepository.update(self)

  end

  # Compile the receiver, render it, and store the
  # rendered text in self.compiled_and_rendered_content
  def compile_with_render(option={})
    puts "compile_with_render, id = #{self.id}, title = #{self.title}".yellow
    format = self.render_options['format']

    case format
      when 'adoc'
        render_option = {}
      when 'adoc-latex'
        render_option = {backend: 'html5'}
      else
        render_option = {}
    end


    dirty = self.compiled_dirty
    dirty = true if dirty.nil?

    if dirty
      puts "compile_with_render (dirty): id = #{self.id}, title = #{self.title}".magenta
      renderer = Render.new(self.compile, render_option )
      compiled_content = self.compile
      self.compiled_and_rendered_content = renderer.convert
      self.compiled_dirty = false
      DocumentRepository.update(self)
    else
      puts "compile_with_render (clean): id = #{self.id}, title = #{self.title}".blue
    end


    if option[:export] == 'yes'
      file_name = self.title.normalize
      path = "outgoing/#{file_name}.adoc"

      IO.write(path, compiled_content)
      export_html(format)
    end

  end

  def export_html(format)

    file_name = self.title.normalize
    path = "outgoing/#{file_name}.adoc"

    case format
      when 'adoc'
        cmd = "asciidoctor #{path}"
      when 'adoc-latex'
        cmd = "asciidoctor-latex -b html #{path}"
      else
        cmd =  "asciidoctor #{path}c"
    end

    system cmd

  end


  #########################################################
  #
  #  TABLE OF CONTENTS
  #
  #########################################################


  def set_toc_dirty
    self.toc_dirty = true
    self.root_document.toc_dirty = true
  end

  def set_toc_clean
    self.toc_dirty = false
    self.root_document.toc_dirty = false
  end

  def toc_is_dirty
    self.root_document.toc_dirty
  end


  def toc_message
    puts "UPDATE TABLE OF CONNTENTS -- BOSS, I AM WORKING!".magenta
    case self.toc_dirty
      when nil
        puts "update_table_of_contents, id = #{self.id}, title = #{self.title}, dirty = #{self.toc_dirty}".red
      when true
        puts "update_table_of_contents, id = #{self.id}, title = #{self.title}, dirty = #{self.toc_dirty}".yellow
      when false
        puts "update_table_of_contents, id = #{self.id}, title = #{self.title}, dirty = #{self.toc_dirty}".cyan
      else
        puts "update_table_of_contents, id = #{self.id}, title = #{self.title}, dirty = #{self.toc_dirty}".magenta
    end
  end

  # A table of contents is a list of lists,
  # where the sublists are of the form
  # [id, title].  #update_table_of_contents
  # creates this list from scratch, then stores
  # it as jsonb in the toc field of the database
  def update_table_of_contents(arg = {force: false})


    puts "arg = #{arg.to_s}".red

    dirty =  self.root_document.toc_dirty || arg[:force]

    if dirty == false
      puts "BOSS, no update for the table of contents is needed".blue
      return
    end

    toc_message

    value = []
    subdoc_refs.each do |id|
      hash = {}
      hash['id'] = id
      section = DocumentRepository.find(id)
      section.toc_dirty = false
      if section.subdoc_refs
        puts "I will now upddate toc for section #{section.title} with hash = #{arg}".yellow
        section.update_table_of_contents(arg)
      else
        puts "No upddate of toc for section #{section.title}".green
      end
      hash['title'] = section.title
      value << hash
      puts hash.to_s.blue
      DocumentRepository.update section
    end

    self.toc = value
    self.toc_dirty = false
    puts "I set toc_dirty = #{self.toc_dirty}  for id = #{self.id}, title = #{self.title}".magenta
    self.root_document.toc_dirty = false
    DocumentRepository.persist(self)
    value
  end

  def update_table_of_contents_at_root
    root_document.update_table_of_contents
  end






end
