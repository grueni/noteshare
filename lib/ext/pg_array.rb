
# lib/ext/pg_array.rb
require 'lotus/model/coercer'
require 'sequel'
require 'sequel/extensions/pg_array'
require 'sequel/extensions/pg_hstore'
require 'sequel/extensions/pg_json'

Sequel.extension :pg_array_ops
Sequel.extension :pg_hstore_ops
Sequel.extension :pg_json_ops

# Sequel.extension :pg_json_ops


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

class PGHStore < Lotus::Model::Coercer
  def self.dump(value)
    ::Sequel.pg_hstore(value, :text)
  end

  def self.load(value)
    ::Kernel.Array(value) unless value.nil?
  end
end



class PGJSONb < Lotus::Model::Coercer
  def self.dump(value)
    Sequel.pg_jsonb(value)
  end

  def self.load(value)
    JSON.parse(value) unless value.nil?
  end
end

