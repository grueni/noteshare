

module Noteshare
  module Core
    module Yada
      class Foo

        def initialize(incoming)
          @message  = incoming
        end

        def display
          puts "bar: #{@message}".red
        end

      end
    end
  end
end