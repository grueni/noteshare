class Exporter


  def initialize(document)
    @document = document
  end

  def folder
    "outgoing/#{@document.id}"
  end

  def adoc_file_path
    file_name = @document.title.normalize
    "#{folder}/#{file_name}.adoc"
  end

  def latex_file_path
    file_name = @document.title.normalize
    "#{folder}/#{file_name}.tex"
  end

  def latex_file_name
    file_name = @document.title.normalize
    "#{file_name}.tex"
  end

  def export_adoc
    cm = ContentManager.new(@document, doc_folder: @document.id)
    cm.export_adoc
  end


  def export_latex
    system("mkdir -p outgoing/#{@document.id}/images")
    self.export_adoc
    cmd = "asciidoctor-latex -a inject_javascript=no #{adoc_file_path}"
    system(cmd)
    system("tar -cvf #{folder}.tar #{folder}")
    puts "FILE_NAME: #{@document.id}.tar".red
    puts "TMPFILE: #{folder}.tar".red
    AWS.upload("#{@document.id}.tar", "#{folder}.tar", 'latex')
    # def self.upload(file_name, tmpfile, folder='tmp')
  end

end