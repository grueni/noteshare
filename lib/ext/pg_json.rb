



require 'lotus/model/coercer'
require 'sequel'
require 'sequel/extensions/pg_json'

module Database

  Sequel.extension :pg_json
  Sequel.extension :pg_json_ops

  class PGJSONB  < Lotus::Model::Coercer

    def self.dump(value)
      puts "JSONB DUMP: #{value}".red
      Sequel.pg_jsonb(value)
    end

    def self.load(value)
      puts "JSONB LOAD: (#{value})".red
      value
    end


  end

end




