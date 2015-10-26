module NSDocument::Asciidoc

  def prepare_content(document, new_content)
    puts "XXX: entering prepare_content"

    if document
      puts "document title = #{document.title}"
    else
      puts "DOCUMENT IS NIL"
    end

    if new_content
      puts "new_contente = #{new_content}"
    else
      puts "new_content IS NIL"
    end


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

    puts "prepared conetent = #{prepared_content}"
    prepared_content
  end

  def prepare_content2(document, new_content)
   new_content
  end

end