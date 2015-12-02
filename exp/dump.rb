require 'asciidoctor'
str = IO.read(ARGV[0])
a = Asciidoctor.load str, {sourcemap: true}
b = a.blocks

puts b

puts '============='

puts b[0]
puts b[0].title
puts b[0].level
puts b[0].caption
