require 'spec_helper'
require_relative '../../../lib/noteshare/modules/asciidoctor_helpers'

include Noteshare::AsciidoctorHelper

describe AsciidoctorHelper do

  before do

    @input_1 = <<EOF

== One

test of one

== Two

test of two

=== Two.One

test of subsection Two.One

=== Two.Two

test of subsection Two.Two

== Three

test of three


EOF

    @expected_output_1 = <<EOF
<ul class='inner_toc'>
  <li class='inner_toc'> <a href='#_one'> One</a></li>
  <li class='inner_toc'> <a href='#_two'> Two</a></li>
  <ul class='inner_toc'>
    <li class='inner_toc'> <a href='#_two_one'> Two.One</a></li>
    <li class='inner_toc'> <a href='#_two_two'> Two.Two</a></li>
  </ul>
  <li class='inner_toc'> <a href='#_three'> Three</a></li>
</ul>
EOF

    @expected_output_2 = <<EOF
<ul class='inner_toc'>
  <li class='inner_toc'> <a href='#_one'> 1. One</a></li>
  <li class='inner_toc'> <a href='#_two'> 2. Two</a></li>
  <ul class='inner_toc'>
    <li class='inner_toc'> <a href='#_two_one'> 2.1. Two.One</a></li>
    <li class='inner_toc'> <a href='#_two_two'> 2.2. Two.Two</a></li>
  </ul>
  <li class='inner_toc'> <a href='#_three'> 3. Three</a></li>
</ul>
EOF


  end

  describe 'table of contents' do

    it 'can parse asciidoctor text and produce a table of contents as HTML' do

      output = Noteshare::AsciidoctorHelper.table_of_contents(@input_1, [:root, :internal])
      output.must_equal(@expected_output_1)

    end

    it 'can number the sections' do

      input = ":numbered:\n\n#{":numbered:\n\n" + @input_1}"
      output = Noteshare::AsciidoctorHelper.table_of_contents(input, [:root, :internal, :numbered])
      output.must_equal(@expected_output_2)

    end

  end




end