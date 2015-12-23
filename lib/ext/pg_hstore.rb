
require 'lotus/model/coercer'
require 'sequel'
require 'sequel/extensions/pg_hstore'

Sequel.extension :pg_hstore_ops


class PGHStore < Lotus::Model::Coercer
  def self.dump(value)
    ::Sequel.hstore(value)
  end

  def self.load(value)
    return {} if value == nil
    return {} if value.length < 3
    return {} if value[0] != '['
    puts "hstore value: #{value}".red
    value == nil ? {} :  ::Kernel.Hash(value)
  end
end
