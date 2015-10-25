module NSDocument::Asciidoc

  def prepare_content(document, new_content)
    prefix = "="*(document.level + 2)
    header = "#{prefix} #{document.title}"
    if new_content
      "#{header}\n\n#{new_content}"
    else
      header
    end
  end

end