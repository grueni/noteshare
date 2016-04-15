require 'lotus/interactor'

module Noteshare
  module Interactor
    module Document


      class Exporter

        include Lotus::Interactor
        include ::Noteshare::Core::Document

        expose :message, :redirect_path


        def initialize(params)
          id = params[:id]
          @document = Noteshare::Core::Document::DocumentRepository.find id
        end

        def call
          if @document
            @document = @document.root_document
            export_latex
            @message = make_message
          else
            @redirect_path = "/error:#{id}?Document not found" if @document == nil
          end
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
          cm = Noteshare::Core::Document::ContentManager.new(@document, doc_folder: @document.id)
          cm.export_adoc
        end


        def export_latex
          system("mkdir -p outgoing/#{@document.id}/images")
          self.export_adoc
          cmd = "asciidoctor-latex -a inject_javascript=no #{adoc_file_path}"
          system(cmd)
          # system("tar -cvf #{folder}.tar #{folder}/")
          system("cd outgoing; tar -cvf ../#{folder}.tar #{@document.id}/; cd ..")
          puts "FILE_NAME: #{@document.id}.tar".red
          puts "TMPFILE: #{folder}.tar".red
          Noteshare::AWS.upload("#{@document.id}.tar", "#{folder}.tar", 'latex')
        end

        def make_message
          output = "<p style='margin:3em;'> <strong>#{@document.title}</strong> exported as Asciidoc and LaTeX to "
          output << "<a href='http://vschool.s3.amazonaws.com/latex/#{@document.id}.tar'>this link</a> "
          output << "<p style='margin:3em;'> The file to download from the link is #{@document.id}.tar</p>"
          output << "</p>\n\n"
        end

      end

    end
  end
end
