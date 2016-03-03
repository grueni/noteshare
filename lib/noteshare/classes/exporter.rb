class Exporter


  def init(document)
    @document = document
  end

  def adoc_file_path
    file_name = @document.title.normalize
    "outgoing/#{file_name}.adoc"
  end

  def export_adoc
    header = '= ' << @document.title << "\n"
    header << @document.author << "\n"
    header << ":numbered:" << "\n"
    header << ":toc2:" << "\n\n\n"

    renderer = Render.new(header + texmacros + @document.compile, @options )
    renderer.rewrite_media_urls

    IO.write(adoc_file_path, renderer.source)
  end


  def run_asciidoctor_for_latex(course, option)
    cmd = 'asciidoctor-latex -a inject_javascript=no ' + "#{adoc_local_file(course)}"
    system(cmd)
  end

end