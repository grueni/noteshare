class Document
  include Lotus::Entity
  attributes :id, :author, :title, :tags, :meta,
    :created_at, :modified_at, :content, :subdoc_refs, :parent_id,
    :type, :author_id, :area, :rendered_content, :doc_refs, :index_in_parent



  def initialize(hash)
    hash.each { |name, value| instance_variable_set("@#{name}", value) }
    @subdoc_refs = []
    @doc_refs = {}
  end


  def add_to(parent_document)
    DocumentRepository.persist(self) unless self.id

    # add the subdocument
    parent_document.subdoc_refs ||= []
    parent_document.subdoc_refs << self.id

    # refer to the parent in the added document
    self.index_in_parent =  parent_document.subdoc_refs.length - 1
    self.parent_id = parent_document.id

    # set the previous subdoc link
    previous_doc_id = parent_document.subdoc_refs[-2]
    if previous_doc_id
      self.set_previous_doc(previous_doc_id)
      previous_doc = DocumentRepository.find previous_doc_id
      previous_doc.set_next_doc(self.id)
      # puts "PREV: #{previous_doc.status}"
    end

    DocumentRepository.persist(self)
    DocumentRepository.persist(parent_document)
  end


  # *section.add_to(doc)* appends the id of *section*
  # to the array *doc.subdoc_refs*.  It also creates
  # a pointer (*parent_id*) to the parent document
  def xadd_to(parent_document)
    # DocumentRepository.persist(pa
    # add the subdocument
    parent_document.subdoc_refs ||= []
    parent_document.subdoc_refs << self.id

    # refer to the parent in the added document
    self.index_in_parent =  parent_document.subdoc_refs.length - 1
    self.parent_id = parent_document.id

    # DocumentRepository.persist(self)

    # set the previous subdoc link
    previous_doc_id = parent_document.subdoc_refs[-2]
    if previous_doc_id
      puts "+++++++++++++++++"
      self.set_previous_doc(previous_doc_id)
      puts self.status
      previous_doc = DocumentRepository.find previous_doc_id
      puts  "1) >>> #{previous_doc.status}"
      previous_doc.set_next_doc(self.id)
      puts  "2) >>> #{previous_doc.status}"
      # DocumentRepository.persist(previous_doc)
      #nputs "Persisted: #{previous_doc.title}"
      # puts "PREV: #{previous_doc.status}"
      DocumentRepository.persist(previous_doc)
    end


    DocumentRepository.persist(self)
    DocumentRepository.persist(parent_document)
  end

  def x_add_to(parent_document)
    refs = parent_document.subdoc_refs || []
    n = refs.length
    insert(n, parent_document )
  end


  # Insert a subdocument at position k
  # and update all links: parent, index_in_parent,
  # amd the relevant next and previous links
  def insert(k, parent_document)

    index = parent_document.subdoc_refs || []
    index.insert(k, self.id)
    parent_document.subdoc_refs = index
    self.index_in_parent =  k
    self.parent_id = parent_document.id
    DocumentRepository.persist(self )

    n = index.length

    if k > 0
      self.set_previous_doc(index[k-1])
      parent_document.subdocument(k-1).set_next_doc(self.id)
    end

    if k+1 < n
      self.set_next_doc(index[k+1])
      parent_document.subdocument(k+1).set_previous_doc(self.id)
    end

    DocumentRepository.persist(self)

  end

  def info
    "#{self.title}:: id: #{self.id}"
  end

  def status
    "#{self.title}:: id: #{self.id}, parent: #{self.parent.id }, doc_refs: #{self.doc_refs}" # ", back: #{self.doc_refs['previous']}, next: #{@self.doc_refs['next']}"
  end

  def next_document
    DocumentRepository.find doc_refs['next'] if doc_refs
  end

  def previous_document
    DocumentRepository.find doc_refs['previous']
  end

  def set_previous_doc(id)
    hash = self.doc_refs || {}
    hash['previous'] = id
    self.doc_refs = hash
    DocumentRepository.persist(self)
  end

  def set_next_doc(id)
    hash = self.doc_refs || {}
    hash['next'] = id
    self.doc_refs = hash
    DocumentRepository.persist(self)
  end

  # *doc.parent* returns nil or the parent object
  def parent
    DocumentRepository.find(parent_id)
  end

  # *doc.subdocment(k)* returns the k-th
  # subdocument of *doc*
  def subdocument(k)
    DocumentRepository.find(subdoc_refs[k])
  end

  def next_document
    id = self.doc_refs['next']
    DocumentRepository.find id.to_i if id
  end

  def previous_document
    id = self.doc_refs['previous']
    DocumentRepository.find id.to_i if id
  end

  def previous_document_title
    doc = self.previous_document
    doc ? doc.title : 'X'
  end

  def next_document_title
    doc = self.next_document
    doc ? doc.title : 'X'
  end


  # *doc.subdocument_titles* returns a list of the
  # titles of the sections of *document*.
  def subdocument_titles(option=:simple)
    list = []
    if option == :header
      list << self.title.upcase
    end
    subdoc_refs.each do |id|
      section = DocumentRepository.find(id)
      if option == :simple or option ==:header
        item = section.title
      elsif option == :verbose
        item = "#{section.title}. back: #{section.previous_document_title}, forward: #{section.next_document_title}"
      end
      list << item
    end
    list
  end


  # *doc.compile* concatenates the contents
  # of *doc* with the compiled text of
  # each section of *doc*.  The sections
  # array is determined by #part, which is
  # a persistent array of integers which
  # represent the id's of the sections of
  # *doc*.
  def compile
    puts "compiling #{self.title} with array = #{self.subdoc_refs}"
    compiled_text = self.content || ''
    if subdoc_refs != []
      subdoc_refs.each do |id|
        section = DocumentRepository.find(id)
        compiled_text << "\n" << section.compile
      end
    else
      puts "stopping at #{self.title} with array = #{subdoc_refs} "
    end
    compiled_text
  end


  def xcompile
    compiled_text = self.content || 'Yo! '
    subdoc_refs.each do |id|
      section = DocumentRepository.find(id)
      compiled_text << "\n" << section.content
      puts section.subdoc_refs
      if section.subdoc_refs != []
        puts "OK! diving ..."
        compiled_text << section.compile
      end
    end
    compiled_text
  end


end
