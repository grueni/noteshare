class Exporter


  def initialize(document)
    @document = document
  end

  def adoc_file_path
    file_name = @document.title.normalize
    "outgoing/#{file_name}.adoc"
  end

  def latex_file_path
    file_name = @document.title.normalize
    "outgoing/#{file_name}.tex"
  end

  def latex_file_name
    file_name = @document.title.normalize
    "#{file_name}.tex"
  end

  def export_adoc
    cm = ContentManager.new(@document)
    cm.export_adoc
  end


  def export_latex
    self.export_adoc
    cmd = "asciidoctor-latex -a inject_javascript=no #{adoc_file_path}"
    system(cmd)
    #  AWS.upload(latex_file_name, latex_file_path, folder='tmp')
  end

end