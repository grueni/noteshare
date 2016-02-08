
class AssociateDocManager


  def initialize(document)
    @document = document
  end


  # @foo.associate_to(@bar, 'summary',)
  # associates @foo to @bar as a 'summary'.
  # It can be retrieved as @foo.associated_document('summary')
  def associate_to(parent, type)
    parent.doc_refs[type] = @document.id
    @document.type = 'associated:' + type
    @document.set_parent_document_to(parent)
    @document.set_root_document_to(parent)
    DocumentRepository.update(parent)
    DocumentRepository.update(@document)
  end

  # Add associat to receiver
  # Example
  #
  #    @content = 'Dr. Smith said that conservation laws ...'
  #    @article.add_associate(title: 'Notes from class', type: 'note', content: @content)
  #
  def add_associate(hash)

    type = hash.delete(:type)

    doc = NSDocument.new(hash)
    doc.identifier = Noteshare::Identifier.new().string
    doc.root_ref = { 'id'=> 0, 'title' => ''}
    doc.author_id = @document.author_id
    doc.author = @document.author
    doc.author_credentials2 = @document.author_credentials2

    doc.info
    doc2 = DocumentRepository.create doc

    associate_to(@document, type)

  end


  # The method below assumes that a document
  # is the associate of at most one other
  # document.  This should be enforced (#fixme)
  def disassociate
    _parent = parent_document
    _type = @document.type.sub('associated:', '')
    _parent.doc_refs.delete(_type)
    @document.parent_id = 0
    @document.parent_ref =  nil
    @document.root_document_id = 0
    @document.root_ref = nil
    DocumentRepository.update(_parent)
    DocumentRepository.update(@document)
  end

  def delete_associated_document
    disassociate
    DocumentRepository.delete @document
  end

  # @foo.associatd_document('summary')
  # retrieve the document associated to
  # @foo which is of type 'summary'
  def associated_document(type)
    DocumentRepository.find(@document.doc_refs[type])
  end

  # return hash of associates of a given document
  def associates
    @document.doc_refs
  end



  ############################################################

  # EXTERNAL (3)
  def root_associated_document_map(target='reader')
    root = @document.root_document || @document
    if root != @document
      adm = AssociateDocManager.new(root)
      adm.associated_document_map(target)
    else
      associated_document_map(target)
    end
  end

  # Remove stale keys
  # Fixme: this will become obsolete
  # when things are working better
  def heal_associated_docs
    bad_keys = []
    @document.doc_refs do |key, value|
      if DocumentRepository.find key == nil
        bad_keys << key
      end
    end
    bad_keys.each do |key|
      @document.doc_refs.delete(key)
    end
    DocumentRepository.update @document
  end

  # ONE INTERNAL USE
  def associated_document_map(target='reader')

    heal_associated_docs

    if @document.type =~ /associated:/
      document = @document.parent_document
    else
      document = @document
    end

    hash = document.doc_refs
    keys = hash.keys
    if keys
      keys.delete 'previous'
      keys.delete 'next'
      keys.delete 'index'
      map = "<ul>\n"
      keys.sort.each do |key|
        if target == 'editor'
          map << '<li>' << "#{@document.associate_link(key, 'editor')}</li>\n"
        else
          map << '<li>' << "#{@document.associate_link(key)}</li>\n"
        end
      end
      map << "</ul>\n"
    else
      map = ''
    end
    map
  end


end