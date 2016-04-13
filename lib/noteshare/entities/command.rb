module Noteshare
  module Tool
    module CommandProcessor
      class Command
        include Lotus::Entity

        attributes :token, :command_verb, :args, :created_at, :expires_at, :next_token

      end
    end
  end
end


