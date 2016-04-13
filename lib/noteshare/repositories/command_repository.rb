module Noteshare
  module Tool
    module CommandProcessor
      class CommandRepository
        include Lotus::Repository

        def self.with_token(token)
          query do
            where(token: token)
          end.first
        end
      end

    end
  end
end

