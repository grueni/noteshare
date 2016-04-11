require 'pry'


# The AssociateDocumentManager class
# is responsible for adding, manipulating,
# and deleteing associates documents
class AssociateDocumentManager

  def initialize(parent_document)
    @parent_document = parent_document
  end


  def attach(document, type)
    @parent_document.doc_refs2 ||= {}
    @parent_document.doc_refs2[document.id.to_s] = type
    document.type = 'associated:' + type
    document.set_parent_document_to(@parent_document)
    document.set_root_document_to(@parent_document)
    DocumentRepository.update(@parent_document)
    DocumentRepository.update(document)
  end


  def get(type)
    assoc_docs = []
    @parent_document.doc_refs2.keys.each do |key|
      if @parent_document.doc_refs2[key] == type
        assoc_docs << DocumentRepository.find(key.to_i)
      end
    end
    assoc_docs
  end

  def get_one(type)
    get(type)[0]
  end


  def add(hash)

    type = hash.delete(:type)

    doc = NSDocument.new(hash)
    doc.identifier = Noteshare::Identifier.new().string
    doc.root_ref = { 'id'=> 0, 'title' => ''}
    doc.author_id = @parent_document.author_id
    doc.author = @parent_document.author
    doc.author_credentials2 = @parent_document.author_credentials2

    doc2 = DocumentRepository.create doc

    attach(doc2, type)

    doc2

  end

  # The method below assumes that a document
  # is the associate of at most one other
  # document.  This should be enforced (#fixme)
  def detach(document)
    @parent_document.doc_refs2.delete(document.id.to_s)
    document.parent_id = 0
    document.parent_ref =  nil
    document.root_document_id = 0
    document.root_ref = nil
    DocumentRepository.update(@parent_document)
    DocumentRepository.update(document)
  end

  def delete(document)
    detach(document)
    DocumentRepository.delete document
  end

end