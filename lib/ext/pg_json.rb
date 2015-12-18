=begin

require 'lotus/model/coercer'
require 'sequel'

Sequel.extension :pg_json_ops



class PGJSONb < Lotus::Model::Coercer
  def self.dump(value)
    Sequel.pg_jsonb(value)
  end

  def self.load(value)
    JSON.parse(value) unless value.nil?
  end
end

=end