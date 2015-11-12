
# lib/ext/pg_array.rb
require 'lotus/model/coercer'
require 'sequel'
require 'sequel/extensions/pg_array'
# require 'sequel/extensions/pg_json'

Sequel.extension :pg_array_ops


class PGIntArray < Lotus::Model::Coercer
  def self.dump(value)
    ::Sequel.pg_array(value, :integer)
  end

  def self.load(value)
    ::Kernel.Array(value) unless value.nil?
  end
end


class PGJsonb < Lotus::Model::Coercer
  def self.dump(value)
    Sequel.pg_jsonb(value)
  end

  def self.load(value)
    JSON.parse(value) unless value.nil?
  end
end

