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


  def self.spacing(section, offset=0)
      "  "*(section.level + offset)
    end

    def self.toc_entry(section, hash )
      puts "#{section.level}: #{section.title}".red

      options = hash[:options]
      doc_id = hash[:doc_id]
      options.include?(:numbered) ? prefix = "#{section.sectnum} " : prefix = ''

      if options.include? :internal
        "<a href='\##{section.id}'> #{prefix}#{section.title}</a>"
      elsif options.include? :external
        # used by noteshare
        "<a href='/document/#{doc_id}?#{section.id}'> #{prefix}#{section.title}</a>"
      elsif options.include? :inactive
        # used by noteshare
        "<a href='#'> #{prefix}#{section.title}</a>"
      else
        "<a href='\##{section.id}'> #{prefix}#{section.title}</a>"
      end

    end

    def self.table_of_contents(text, hash = { options: [:root, :internal],  doc_id: 0 })

      options = hash[:options]
      doc = Asciidoctor.load text, {sourcemap: true}
      doc_id = hash[:doc_id]

      @level = 0
      @previous_level = 0

      if options.include? :inactive
        ul = "<ul class='inner_toc null'>"
        li = "<li class='inner_toc null'>"
      else
        ul = "<ul class='inner_toc'>"
        li = "<li class='inner_toc'>"
      end

      sections = doc.find_by context: :section

      toc_string = ''
      stack = []
      options.include?(:root) ? first_index = 0 : first_index = 1

      if sections
        last_index = sections.length-1
        sections[first_index..last_index].each do |section|

          @level = section.level
          if @level > @previous_level
            n = @level - @previous_level
            n.times do
              toc_string << "#{self.spacing(section,-1)}#{ul}" << "\n"
              stack.push('</ul>')
            end
          elsif @level < @previous_level
            n = @previous_level - @level
            n.times do
              token = stack.pop
              toc_string << "#{self.spacing(section,0)}#{token}" << "\n"
            end
          end

          if section.level == 0
            toc_string << "<h5><a href='/compiled/#{doc_id}'>#{section.title}</a></h5>" << "\n"
            puts "section level 0, title = #{section.title}, id = #{doc_id}".magenta
          else
            toc_string << "#{self.spacing(section)}#{li} #{self.toc_entry(section, hash)}" << "</li>\n"
          end

          @previous_level = @level
        end

        while stack.count > 0
          token = stack.pop
          toc_string << "  "*stack.count << token << "\n"
        end

      end
      toc_string
    end

  end
end