
require 'lotus/model/coercer'
require 'sequel'
require 'sequel/extensions/pg_hstore'

Sequel.extension :pg_hstore_ops


class PGHStore < Lotus::Model::Coercer
  def self.dump(value)
    ::Sequel.hstore(value)
  end

  def self.load(value)
    # ::Kernel.Hash(value.to_matrix) unless value.nil?
    if value.nil?
      {}
    else
      ::Kernel.Hash(value)
    end
  end
end
