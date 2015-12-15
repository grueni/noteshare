require 'spec_helper'
require_relative '../modules/document_index_spec'
require 'asciidoctor'

def squeeze(str)
  str.gsub("\n",  '')
end

describe DocumentIndex do



  before do

    @css = '<style> .index_term { color: red; } </style>'

    @short_text = <<EOF
An  ((atom)) is composed of ((electrons)),
((protons)) and ((neutrons)).
EOF

    @more_elaborate_text = <<EOF
    The reign of the (((Time Lords))) began
with the ascension of Viktor Ugg to the throne
of (((Bedamshur))), a planet nearer to the
galactic center than our own planet, still
known as (((Earth))).
EOF

    @short_text_index = <<EOF

.*A*
* <<index_term_0, atom>>


.*E*
* <<index_term_1, electrons>>


.*N*
* <<index_term_3, neutrons>>


.*P*
* <<index_term_2, protons>>

EOF

    @more_elaborate_text_processed = <<EOF
    The reign of the index_term::['Time Lords', 0, invisible] began
with the ascension of Viktor Ugg to the throne
of index_term::['Bedamshur', 1, invisible], a planet nearer to the
galactic center than our own planet, still
known as index_term::['Earth', 2, invisible].
EOF

    @short_text_html = <<EOF
<div class="paragraph">
<p>An  <span class='index_term' id='index_term_0'>atom</span> is composed of <span class='index_term' id='index_term_1'>electrons</span>,
<span class='index_term' id='index_term_2'>protons</span> and <span class='index_term' id='index_term_3'>neutrons</span>.</p>
</div>
EOF


  end




  it 'can construct an index for terms like ((atom))' do

    indexer = DocumentIndex.new(string: @short_text)
    indexer.scan
    indexer.make_index_map
    index =  indexer.make_index
    squeeze(index).must_equal(squeeze(@short_text_index))

  end

  it 'can preprocess the input text' do

    indexer = DocumentIndex.new(string: @short_text)
    indexer.preprocess_to_string
    processed_text = indexer.output
    html = Asciidoctor.convert processed_text
    squeeze(html).must_equal(squeeze(@short_text_html))

    # puts @css <<"\n\n" << html

  end

  it 'can preprocess input text with items marked like (((this)))' do

    indexer = DocumentIndex.new(string: @more_elaborate_text)
    indexer.preprocess_to_string
    processed_text = indexer.output
    html = Asciidoctor.convert processed_text
    squeeze(processed_text).must_equal(squeeze(@more_elaborate_text_processed))
    puts processed_text

    # puts @css <<"\n\n" << html

  end


end