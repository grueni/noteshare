
class AssociateDocManager


  def initialize(document)
    @document = document
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