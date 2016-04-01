# The AssociateDocumentManager class
# is responsible for adding, manipulating,
# and deleteing associates documents
class AssociateDocumentManager

  def initialize(parent_document)
    @parent_document = parent_document
  end

  # @foo.associate_to(@bar, 'summary',)
  # associates @foo to @bar as a 'summary'.
  # It can be retrieved as @foo.associated_document('summary')
  def associate(document, type)
    @parent_document.doc_refs[type] = self.id
    document.type = 'associated:' + type
    document.set_parent_document_to(@parent_document)
    document.set_root_document_to(@parent_document)
    DocumentRepository.update(@parent_document)
    DocumentRepository.update(document)
  end

end