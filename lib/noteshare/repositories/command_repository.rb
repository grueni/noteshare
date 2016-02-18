class CommandRepository
  include Lotus::Repository

  def self.with_token(token)
    query do
      where(token: token)
    end.first
  end

  
end
