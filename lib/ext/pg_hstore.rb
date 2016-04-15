
require 'lotus/model/coercer'
require 'sequel'
require 'sequel/extensions/pg_hstore'

module Database


  Sequel.extension :pg_hstore_ops

  class PGHStore < Lotus::Model::Coercer

    def self.dump(value)
      # puts "HSTORE DUMP #{value}".red
      value = {} if value == nil
      ::Sequel.hstore(value)
    end

    def self.load(value)
      # puts "HSTORE LOAD #{value}".red
      value == nil ? {} :  ::Kernel.Hash(value)
    end
  end


end
