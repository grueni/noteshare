=begin
# lib/ext/pg_array.rb
require 'lotus/model/coercer'
require 'sequel'
require 'sequel/extensions/pg_array'



class PGArray < Lotus::Model::Coercer
  def self.dump(value)
    ::Sequel.pg_array(value, :varchar)
  end

  def self.load(value)
    ::Kernel.Array(value) unless value.nil?
  end
end
=end
