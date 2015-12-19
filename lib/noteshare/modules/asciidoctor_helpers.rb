module Noteshare


  # The code below produces a table of contents
  # in HTML form given a string of Asciidoctor
  # text. The code is organied into two sections:
  #
  #   (1) AsciidoctorUtilities
  #   (2) AsciidoctorHelpers
  #
  # The first contains the TOC class
  # (FreestandingTableOfContents) for generic
  # Asciidoctor use.  The second contains a subclass
  # used by Noteshare.

  # For the HTML output to be properly and pleasantly
  # formatted, suitble CSS is needed.  Listed next
  # is an example of how this may be done:

  # .free_toc  ul {
  #
  #     list-style: none;
  #     margin-bottom:0;
  #     padding-left:1em;
  #
  # }
  #
  # .free_toc li  {
  #
  #     font-size:15px;
  #     margin-left: -0.3em;
  #     padding-left:  -0em;
  #     text-indent: -0.1em;
  #
  # }
  #
  # .free_toc > li a {
  #
  #     text-decoration: none;
  # }

  # Fixme: the naming sucks and needs some work.


  module AsciidoctorUtilities

    # FreestandingTableOfContents#table produces a table of contents in HTML form
    # given Asciidoc input.  The output can be configured by setting
    # options as described below.

    # Example:
    #
    #       toc = FreestandingTableOfContents.new(source).table
    #
    # produces a table of contents with default options and stores it in 'toc'

    # Options
    #
    #  There are hooks for options that affect the output that one can implement
    # by either by modifiying the code below or by subclassing.  See, for example,
    # the class TableOfContents < TOC which is listed at the end.


     class TableOfContents

       def initialize(text, _attributes, _options )
         @text = text
         @attributes = _attributes || []
         @options = _options || {}
         @doc_id = @options[:doc_id]
       end

       # To make the HTML code look good for humans
       def spacing(offset=0)
         "  "*(@section.level + offset)
       end


       # Returns the entry in the table of contents for @section;
       # Section numbers are displayed if the 'sectnums' attribute
       # is present.
       def toc_entry
         @attributes.include?('sectnums') ? prefix = "#{@section.sectnum} " : prefix = ''
         "<a href='\##{@section.id}'> #{prefix}#{@section.title}</a>"
       end


       # Set @ul and @li in accord with the options
       # 'inner_toc' refers to a CSS class that should give
       # proper indentation.
       def setup_list
         @ul = "<ul class='free_toc'>"
         @li = "<li class='free_toc'>"
       end

       # Manage the stack that is used to ensure proper
       # indentation of the list.
       def update_ul_stack
         if @level > @previous_level
           n = @level - @previous_level
           n.times do
             @toc_string << "#{spacing(-1)}#{@ul}" << "\n"
             @ul_stack.push('</ul>')
           end
         elsif @level < @previous_level
           n = @previous_level - @level
           n.times do
             token = @ul_stack.pop
             @toc_string << "#{spacing(0)}#{token}" << "\n"
           end
         end
       end

       # @toc_string is the instance variable in which the output is
       # accumulated.  The action of 'update_toc_string' depends on
       # the level of @section.  If it is zero, a heading is appended
       # to @toc_string. Otherwise, the toc_entry as a list item is appended.
       def update_toc_string
           @toc_string << "#{spacing}#{@li} #{toc_entry}" << "</li>\n"
       end

       # Make sure that the stack has been consumed.
       def tidy_up
         while @ul_stack.count > 0
           token = @ul_stack.pop
           @toc_string << "  "*@ul_stack.count << token << "\n"
         end
       end

       def setup_table

         source = @text || ''

         doc = Asciidoctor.load source, sourcemap: true, attributes: @attributes

         @level = 0
         @previous_level = 0

         setup_list

         @sections = doc.find_by context: :section

         # Fixme: this code is questionable
         if @attributes.include? 'auto_level' && @sections && @sections.count > 0
           @level = @sections[0].level
         end

         return '' if @sections == nil

         @toc_string = ''
         @ul_stack = []
         @attributes.include?('skip_first_item') ? @first_index = 1 : @first_index = 0
         @last_index = @sections.length-1

       end

       # Set up the table and iterate over @sections to produce the
       # HTML table that we want.
       def table

         setup_table

         if @sections

           @sections[@first_index..@last_index].each do |section|

             @section  = section
             @level = @section.level

             update_ul_stack
             update_toc_string

             @previous_level = @level

           end

           tidy_up

         end
         @toc_string
       end
     end

  end


  module AsciidoctorHelper
    include AsciidoctorUtilities


    # TableOfContents#table is a subclass of FreestandingTableOfContents used by Noteshare.
    #
    # It produces a table of contents in HTML form
    # given Asciidoc input.  The output can be configured by setting
    # options as described below.

    # Example:
    #
    #       toc = Noteshare::AsciidoctorHelper::TableOfContents.new(source).table
    #
    # produces a table of contents with default options and stores it in 'toc'

    # Options
    #
    #     :internal or :external, :root, :numbered .e.g, [:root, :internal, :numbered]
    #
    # :root and :internal should be used in most situations. :external is used by
    # noteshare.  If :root is omitted, then the first entry in the table of contents
    # is omitted. If the :numbered option is present, items in the table of contents
    # will be numbered.  (For the moment this requires ":numbered:\n\n" as the first
    # three lines of the input text.)
    class NSTableOfContents < TableOfContents

      # Returns the entry in the table of contents for @section
      def toc_entry

        @attributes.include?('sectnums') ? prefix = "#{@section.sectnum} " : prefix = ''

        if @attributes.include? 'inert'
          "<a href='#'> #{prefix}#{@section.title}</a>"
        elsif @attributes.include? 'internal'
          "<a href='\##{@section.id}'> #{prefix}#{@section.title}</a>"
        elsif @attributes.include? 'titlepage'
          "<a href='/compiled/#{@doc_id}\##{@section.id}'> #{prefix}#{@section.title}</a>"
        elsif @attributes.include? 'external'
          "<a href='/document/#{@doc_id}?#{@section.id}'> #{prefix}#{@section.title}</a>"
        else
          "<a href='\##{@section.id}'> #{prefix}#{@section.title}</a>"
        end

      end


      # Set @ul and @li in accord with the options
      # 'inner_toc' refers to a CSS class that should give
      # proper indentation. 'null' refers to another CSS
      # class that is used to distinguish inactive items --
      # inactive in the sense that they do not point to
      # anything.
      def setup_list
        css_classes = 'inner_toc'
        css_classes << ' inert' if  @attributes.include? 'inert'
        @ul = "<ul class='#{css_classes}'>"
        @li = "<li class='#{css_classes}'>"
      end

      # @toc_string is the instance variable in which the output is
      # accumulated.  The action of 'update_toc_string' depends on
      # the level fo @section.  If it is zero, a heading is appended
      # to @toc_string. Otherwise, the toc_entry as a list item is appended.
      def update_toc_string
        if @section.level == 0
          @toc_string << "<h5><a href='/compiled/#{@doc_id}'>#{@section.title}</a></h5>" << "\n"
        else
          @toc_string << "#{spacing}#{@li} #{toc_entry}" << "</li>\n"
        end
      end


    end

  end

end