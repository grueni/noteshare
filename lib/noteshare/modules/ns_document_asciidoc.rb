# Fixme -does this solve the Heroku proeduction issue?
# ! Unable to load application: NameError: uninitialized constant NSDocument
# 2015-11-10T12:54:09.371257+00:00 app[web.1]: /app/lib/noteshare/modules/ns_document_asciidoc.rb:1:in `<top (required)>': uninitialized constant NSDocument (NameError)

require_relative '..//entities/ns_document'
require_relative '../modules/toc'


module NSDocument::Asciidoc

  include Noteshare

  def prepare_content(document, new_content)

    if document
      prefix = "="*(document.level + 2)
    else
      prefix = "== "
    end

    if document
      new_title = document.title
    else
      new_title = 'TITLE'
    end

    header = "#{prefix} #{new_title}"

    if new_content
      prepared_content = "#{header}\n\n#{new_content}"
    else
      prepared_content = header
    end

    prepared_content
  end

  # Extract title from content. Thus, if
  # the content is
  #
  # Ho ho ho!
  # === Mr. Klaus and his laugh
  # blah, blah,
  #
  # Then #title_from_content returns
  # the string 'Mr. Klaus and his lauggh'
  def title_from_content
    m = self.content.match /^=* .*$/
    if m
     m[0].gsub(/=*=/, '').strip
    end
  end

  # Return the level of a document  Thus, if
  # the content is
  #
  # Ho ho ho!
  # === Mr. Klaus and his laugh
  # blah, blah,
  # the returned value is 2
  def asciidoc_level
    _content = self.content || ''
    m = _content.match /^(=*) .*$/
    if m
      m[1].length - 1
    else
      0
    end
  end

  # Make document.title agree with what
  # is said in the text.
  def synchronize_title
    old_title = self.title
    new_title = title_from_content
    if new_title and old_title != new_title
      self.title = new_title
      if parent_document
        toc  = TOC.new(parent_document)
        toc.change_title(self.id, new_title)
        toc.save!
        DocumentRepository.update self
      end
    end
  end


end