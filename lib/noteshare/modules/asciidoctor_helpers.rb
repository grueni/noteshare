module Noteshare
  module AsciidoctorHelper

    # table_of_contents(text) produces a table of contents in HTML form
    # given Asciidoc input.  The output can be configured by setting
    # options as described below.

    # Options
    #
    #     :internal or :external, :root, :numbered .e.g, [:root, :internal, :numbered]
    #
    # :root and :internal should be used in most situations. :external is used by
    # noteshare.  If :root is omitted, then the first entry in the table of contents
    # is omitted. If the :numbered option is present, items in the table of contents
    # will be numbered.  (For the moment this requires ":numbered:\n\n" as the first
    # three lines of the input text.)


  def spacing(section, offset=0)
      "  "*(section.level + offset)
    end

    def toc_entry(doc, section, options)

      options.include?(:numbered) ? prefix = "#{section.sectnum} " : prefix = ''

      if options.include? :internal
        "<a href='\##{section.id}'> #{prefix}#{section.title}</a>"
      else
        "<a href='/document/#{doc.id}?#{section.id}'> #{prefix}#{section.title}</a>"
      end

    end

    def table_of_contents(text, options = [:root, :internal])

      doc = Asciidoctor.load text, {sourcemap: true, numbered: true}

      @level = 0
      @previous_level = 0

      ul = "<ul class='inner_toc'>"
      li = "<li class='inner_toc'>"

      sections = doc.find_by context: :section

      toc_string = ''
      stack = []
      options.include?(:root) ? first_index = 0 : first_index = 1
      last_index = sections.length-1

      if sections
        sections[first_index..last_index].each do |section|

          @level = section.level
          if @level > @previous_level
            toc_string << "#{spacing(section,-1)}#{ul}" << "\n"
            stack.push('</ul>')
          elsif @level < @previous_level
            token = stack.pop
            toc_string << "#{spacing(section,0)}#{token}" << "\n"
          end
          toc_string << "#{spacing(section)}#{li} #{toc_entry(self, section, options)}" << "</li>\n"
          @previous_level = @level
        end

        while stack.count > 0
          token = stack.pop
          puts "stack.count: #{stack.count}".red
          toc_string << "  "*stack.count << token << "\n"
        end

      end
      toc_string
    end

  end
end