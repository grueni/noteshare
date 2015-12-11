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

    @input_3 = <<EOF
== Introduction

Common sayings, often regarded as
unimportant, have a huge effect
on human behavior.

== Example

Before presenting our theory of trans-cultural
and trans-generational effects of common sayings,
let us ocnsider

=== Regret

Don't cry over spilled milk

=== Time

A stitch in time saves nine

== Theory

In progress:-)
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

    @expected_output_null_ref = <<EOF
<ul class='inner_toc null'>
  <li class='inner_toc null'> <a href='#'> 1. One</a></li>
  <li class='inner_toc null'> <a href='#'> 2. Two</a></li>
  <ul class='inner_toc null'>
    <li class='inner_toc null'> <a href='#'> 2.1. Two.One</a></li>
    <li class='inner_toc null'> <a href='#'> 2.2. Two.Two</a></li>
  </ul>
  <li class='inner_toc null'> <a href='#'> 3. Three</a></li>
</ul>
EOF

    @book = <<EOF


= A Treatise on Common Sayings
:numbered:

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

  end

  describe 'table of contents' do

    it 'can parse asciidoctor text and produce a table of contents as HTML' do

      toc =  Noteshare::AsciidoctorHelper::TableOfContents.new(@input_1, {options: [:root, :internal]})
      toc.table_of_contents.must_equal(@expected_output_1)

    end

    it 'can number the sections' do

      input = ":numbered:\n\n#{":numbered:\n\n" + @input_1}"
      toc =   Noteshare::AsciidoctorHelper::TableOfContents.new(input, {options: [:root, :internal, :numbered]})
      toc.table_of_contents.must_equal(@expected_output_2)

    end

    it 'can produce a table of contents with inactive references' do

      input = ":numbered:\n\n#{":numbered:\n\n" + @input_1}"
        toc =   Noteshare::AsciidoctorHelper::TableOfContents.new(input, {options: [:root, :inactive, :numbered]})
      toc.table_of_contents.must_equal(@expected_output_null_ref)

    end

  end




end