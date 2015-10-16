require_relative '../../ext/core'

class Document
  include Lotus::Entity
  attributes :id, :author, :title, :tags, :meta,
    :created_at, :modified_at, :content, :subdoc_refs, :parent_id,
    :type, :author_id, :area, :rendered_content, :doc_refs, :index_in_parent



  def initialize(hash)
    hash.each { |name, value| instance_variable_set("@#{name}", value) }
    @subdoc_refs = [] if @subdoc_refs.nil?
    @doc_refs = {} if @doc_refs.nil?
  end



  def add_to(parent_document)
    DocumentRepository.persist(self) unless self.id

    # add the subdocument
    parent_document.subdoc_refs ||= []
    parent_document.subdoc_refs << self.id

    # refer to the parent in the added document
    self.index_in_parent =  parent_document.subdoc_refs.length - 1
    self.parent_id = parent_document.id

    self.set_previous_doc
    if previous_document
      previous_document.set_next_doc
    end

    self.set_next_doc
    if next_document
      next_document.set_previous_doc
    end

    DocumentRepository.persist(self)
    DocumentRepository.persist(parent_document)
  end



  # Insert a subdocument at position k
  # and update all links: parent, index_in_parent,
  # amd the relevant next and previous links
  def insert(k, parent_document)

    # puts "Insert #{self.id} (#{self.title}) at k = #{k}"

    index = parent_document.subdoc_refs || []
    index.insert(k, self.id)
    parent_document.subdoc_refs = index
    self.index_in_parent =  k
    self.parent_id = parent_document.id

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

    self.set_previous_doc
    self.set_next_doc

    if previous_document
      previous_document.set_next_doc
    end

    if next_document
      next_document.set_previous_doc
    end

  end

  # Assume that receiver is subdocument k of parent.
  # Return the id of subdocuemnt k - 1 or nil
  def previous_id
    parent = DocumentRepository.find parent_id
    return nil if index_in_parent-1 < 0
    return parent.subdoc_refs[index_in_parent-1]
  end

  # Assume that receiver is subdocument k of parent.
  # Return the id of subdocuemnt k + 1 or nil
  def next_id
    parent = DocumentRepository.find parent_id
    return nil if index_in_parent+1 > parent.subdoc_refs.length
    parent.subdoc_refs[index_in_parent+1]
  end

  def info
    "#{self.title}:: id: #{self.id}"
  end

  def status
    "#{self.title}:: id: #{self.id}, parent: #{self.parent.id }, doc_refs: #{self.doc_refs}" # ", back: #{self.doc_refs['previous']}, next: #{@self.doc_refs['next']}"
  end

  def next_document
    DocumentRepository.find next_id
  end

  def previous_document
    DocumentRepository.find previous_id
  end

  def set_previous_doc
    self.doc_refs['previous'] = previous_id
    DocumentRepository.persist(self)
  end

  def set_next_doc
    self.doc_refs['next'] = next_id
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
    if [:header].include? option
      list << self.title.upcase
    end
    subdoc_refs.each do |id|
      section = DocumentRepository.find(id)
      if [:header, :simple].include? option
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
    if subdoc_refs == []
      return content
    else
      text = content + "\n" || ''
      subdoc_refs.each do |id|
        section = DocumentRepository.find(id)
        text  << section.compile << "\n"
        # section.xcompile
      end
      return text
    end
  end



end
