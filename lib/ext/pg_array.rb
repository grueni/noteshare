
require 'lotus/model/coercer'
require 'sequel'
require 'sequel/extensions/pg_array'

Sequel.extension :pg_array_ops
Sequel.extension :pg_hstore_ops


class PGIntArray < Lotus::Model::Coercer
  def self.dump(value)
    ::Sequel.pg_array(value, :integer)
  end

  def self.load(value)
    ::Kernel.Array(value) unless value.nil?
  end
end

class PGStringArray < Lotus::Model::Coercer
  def self.dump(value)
    ::Sequel.pg_array(value, :text)
  end

  def self.load(value)
    ::Kernel.Array(value) unless value.nil?
  end
end


