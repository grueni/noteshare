# Fixme -does this solve the Heroku proeduction issue?
# ! Unable to load application: NameError: uninitialized constant NSDocument
# 2015-11-10T12:54:09.371257+00:00 app[web.1]: /app/lib/noteshare/modules/ns_document_asciidoc.rb:1:in `<top (required)>': uninitialized constant NSDocument (NameError)

require_relative '..//entities/ns_document'
require_relative '../modules/toc'


module NSDocument::Asciidoc

  include Noteshare

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
    return if self.is_root_document?
    old_title = self.title || ''
    new_title = title_from_content || ''
    old_title = 'No Title' if old_title == ''
    new_title = 'NO TITLE' if new_title == ''
    if new_title and (old_title != new_title)
      self.title = new_title
      if parent_document
        puts "synchronize_title: Updating parent document".red
        toc  = TOC.new(parent_document)
        toc.change_title(self.id, new_title)
        toc.save!
        DocumentRepository.update self
      end
    end
  end


end