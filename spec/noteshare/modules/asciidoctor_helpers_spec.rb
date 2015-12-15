require 'spec_helper'
require_relative '../../../lib/noteshare/modules/asciidoctor_helpers'

include Noteshare::AsciidoctorHelper
include Noteshare::AsciidoctorUtilities

# The tests below are organized into two sections:
#
#   (1) FreestandingTableOfContents
#   (2) TableOfContents
#
# The first is the TOC class for generic
# Asciidoctor use.  The second is a subclass
# used by Noteshare.

# Fixme: the naming sucks and needs some work.

describe 'FreestandingTableOfContents' do

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



    @book = <<EOF


= A Treatise on Common Sayings

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


  describe '(1) FreestandingTableOfContents' do

    before do

      @expected_output_1 = <<EOF
<ul class='free_toc'>
  <li class='free_toc'> <a href='#_one'> One</a></li>
  <li class='free_toc'> <a href='#_two'> Two</a></li>
  <ul class='free_toc'>
    <li class='free_toc'> <a href='#_two_one'> Two.One</a></li>
    <li class='free_toc'> <a href='#_two_two'> Two.Two</a></li>
  </ul>
  <li class='free_toc'> <a href='#_three'> Three</a></li>
</ul>
EOF

      @expected_output_2 = <<EOF
<ul class='free_toc'>
  <li class='free_toc'> <a href='#_one'> 1. One</a></li>
  <li class='free_toc'> <a href='#_two'> 2. Two</a></li>
  <ul class='free_toc'>
    <li class='free_toc'> <a href='#_two_one'> 2.1. Two.One</a></li>
    <li class='free_toc'> <a href='#_two_two'> 2.2. Two.Two</a></li>
  </ul>
  <li class='free_toc'> <a href='#_three'> 3. Three</a></li>
</ul>
EOF


    end

    it 'can parse asciidoctor text and produce a table of contents as HTML' do

      output =  Noteshare::AsciidoctorUtilities::FreestandingTableOfContents.new(@input_1, ['internal'], {}).table
      output.must_equal(@expected_output_1)

    end

    it 'can number the sections' do

      toc =   Noteshare::AsciidoctorUtilities::FreestandingTableOfContents.new(@input_1, ['internal', 'sectnums'], {})
      toc.table.must_equal(@expected_output_2)

    end


  end




  describe '(2) TableOfContents' do

    before do

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
    end


    it 'can parse asciidoctor text and produce a table of contents as HTML' do

      output =  Noteshare::AsciidoctorHelper::TableOfContents.new(@input_1, ['internal'], {} ).table
      output.must_equal(@expected_output_1)

    end

    it 'can number the sections' do

      input = "'sectnums'\n\n#{"'sectnums'\n\n" + @input_1}"
      toc =   Noteshare::AsciidoctorHelper::TableOfContents.new(input, ['internal', 'sectnums'], {} )
      toc.table.must_equal(@expected_output_2)

    end

    it 'can produce a table of contents in whih all internal references are inert' do

      input = @input_1
      toc =   Noteshare::AsciidoctorHelper::TableOfContents.new(input, ['inert', 'sectnums'],{})
      toc.table.must_equal(@expected_output_2)

    end

  end


end