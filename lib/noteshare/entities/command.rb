require_relative '../repositories/command_repository'

class Command
  include Lotus::Entity

  attributes :token, :command, :args, :created_at, :expires_at

end
