

data = IO.read(ARGV[0])
name = ARGV[0].split('.')[0]
lines = data.split("\n")

dict = {'Integer'=>'integer', 'String'=>'text', 'JSON'=>'jsonb', 'DateTime'=>'timestamp with time zone',
         'PGIntArray'=>'integer[]', 'PGStringArray'=>'text[]', 'Boolean'=>'boolean', 'PGHStore' => 'hstore'}



hash = {}
lines.each do |line|
  item = line.split(' ')
  key = item[1].sub(':', '').sub(',', '')
  hash[key] = dict[item[2]]
end


puts "DROP TABLE #{name};"
puts "CREATE TABLE #{name}("
hash.each do |key, value|
  puts "  #{key} #{value},"
end
puts "PRIMARY KEY(id)"
puts ");"
