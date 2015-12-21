
require 'lotus/model/coercer'
require 'sequel'
require 'sequel/extensions/pg_hstore'

Sequel.extension :pg_hstore_ops


class PGHStore < Lotus::Model::Coercer
  def self.dump(value)
    ::Sequel.hstore(value)
  end

  def self.load(value)
    value = nil if value == nil
    puts "in hstore coercer, value = #{value}".red
    ::Kernel.Hash(value)
    #value.nil?  ? {} :
  end
end
