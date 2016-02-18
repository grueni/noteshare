class Command
  include Lotus::Entity

  attributes :token, :command_verb, :args, :created_at, :expires_at

end
