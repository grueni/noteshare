module Processor::Controllers::User
  class Process
    include Processor::Action

    def call(params)
      token = params['token']
      self.body = "token: #{token}"
    end
  end
end
