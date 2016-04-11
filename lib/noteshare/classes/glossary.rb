module Noteshare
  module Core
    module Text
      # Purpose: read a text that has been marked
      # with glossary entries and produce from it
      # a Glossary in Asciidoc form.  Items in the
      # Glossary should link to the terms they
      # define and conversely glossary terms in
      # the text should link to their listing in
      # the glossary.  Link from glossary to text
      # is handled here.  Link from text to glosasary
      # is handled by Aciiidoctor-LaTeX
      class Glossary

        require 'ostruct'

        attr_reader :text, :entries

        def initialize(input, option={})
          if option == {}
            @text = input
          elsif option == :file
            @text = IO.read input
          end
        end

        def make
          term_list = ordered_dictionary_terms
          @entries = []
          term_list.each do |item|
            term, explanation = item
            entry = OpenStruct.new
            entry.term = glossary_entry(term)
            entry.explanation = explanation
            @entries << entry
          end
          @entries
        end


        def table
          make
          out = "*Glossary* +\n"
          out << "[.glossary_table_style .center]\n"
          out << "[cols='1,3', width=75%]\n"
          out << "|===\n"
          @entries.each do |entry|
            if entry.explanation == ''
              out << "| _#{entry.term}_ | - " << " +\n"
            else
              out << "| _#{entry.term}_ | #{entry.explanation}" << " +\n"
            end
          end
          out << "|===\n"
        end


        # The next two methods are not really part of the public
        # interface, but they are used by the tests.

        # Labran en la glossterm:[penumbra,shadow] los cristales
        # Y la tarde que muere es glossterm:[miedo] y frío.
        #    =>
        # [["penumbra", "shadow"], ["miedo", ""], ... ]
        def dictionary_terms
          regex = /glossterm:\[(.*?)\]|{{(.*?)}}/
          @text.scan(regex).map{ |x| process_term(x) }
          # @index_terms = @text.scan(regex).map{ |x| process_term(x) }
          # d { @index_terms }
          # @index_terms
        end

        def ordered_dictionary_terms
          dictionary_terms.sort{ |x,y| x[0].downcase <=> y[0].downcase }
        end

        private

        @@css_text = <<EOF
<style>
.index_term { color: '#ddd'; }
</style>
EOF


        #### The following three methods are used exclusively by dictionary_term ####

        def parse_term(term)
          term.nil? ? ['nil'] : term.split(',')
        end

        def normalize_term(term)
          term.count == 1 ? [term[0].strip, ''] : [term[0].strip, term[1].strip]
        end

        def process_term(term)
          # normalize_term(parse_term(term[0]))
          item = term[0] || term[1]
          item != '' ? t = parse_term(item) : t = ['undef', 'undef']
          normalize_term(t)
        end


        # glossary_entry is used by 'make' to construct
        # the output Asciidoc text
        # MODEL: <em><a id=gloss_entry_cammin ></a>
        # <a href=#glossterm_cammin >cammin</a></em>
        def glossary_entry(term)
          id = term.gsub(' ', '_').gsub(/\W/, '')
          ref_id = 'glossentry_' + id

          href = 'glossterm_' + id
          "[[#{ref_id}]]\n<<#{href},#{term}>>"
        end


      end
    end
  end
end


