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


     class TableOfContents

       def initialize(text, args)
         @text = text
         @options = args[:options]
         @doc_id = args[:doc_id]
       end

       def spacing(offset=0)
         "  "*(@section.level + offset)
       end

       def toc_entry

         @options.include?(:numbered) ? prefix = "#{@section.sectnum} " : prefix = ''

         if @options.include? :internal
           "<a href='\##{@section.id}'> #{prefix}#{@section.title}</a>"
         elsif @options.include? :external
           # used by noteshare
           "<a href='/document/#{@doc_id}?#{@section.id}'> #{prefix}#{@section.title}</a>"
         elsif @options.include? :inactive
           # used by noteshare
           "<a href='#'> #{prefix}#{@section.title}</a>"
         else
           "<a href='\##{@section.id}'> #{prefix}#{@section.title}</a>"
         end

       end

       def setup_list
         if @options.include? :inactive
           @ul = "<ul class='inner_toc null'>"
           @li = "<li class='inner_toc null'>"
         else
           @ul = "<ul class='inner_toc'>"
           @li = "<li class='inner_toc'>"
         end
       end

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

       def update_toc_string
         if @section.level == 0
           @toc_string << "<h5><a href='/compiled/#{@doc_id}'>#{@section.title}</a></h5>" << "\n"
           puts "section level 0, title = #{@section.title}, id = #{@doc_id}".magenta
         else
           @toc_string << "#{spacing}#{@li} #{toc_entry}" << "</li>\n"
         end
       end

       def tidy_up
         while @ul_stack.count > 0
           token = @ul_stack.pop
           @toc_string << "  "*@ul_stack.count << token << "\n"
         end
       end

       def setup_table

         doc = Asciidoctor.load @text, {sourcemap: true}

         @level = 0
         @previous_level = 0

         setup_list

         @sections = doc.find_by context: :section

         @toc_string = ''
         @ul_stack = []
         @options.include?(:root) ? @first_index = 0 : @first_index = 1
         @last_index = @sections.length-1

       end

       def table_of_contents

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
end