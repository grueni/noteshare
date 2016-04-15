module Noteshare
  module Tool
    module CommandProcessor
      class TokenCommandProcessor
        include Noteshare::Tool::CommandProcessor
        include Noteshare::Helper::UserGroup


        def initialize(hash)
          @user = hash[:user]
          @token_presented = hash[:token]
        end

        def handle_error
          @error
        end


        # hash = { 'command_verb' => the_command_verb, 'args' => the_args, 'days_alive' => N}
        def put(hash)
          command2 = CommandRepository.with_token(@token_presented)
          if command2
            @error = 'token already exists'
            puts @error.red
            return @error
          end

          days_alive = hash[:days_alive].to_i
          command = Command.new(token: @token_presented,
                                command_verb: hash[:command], args: hash[:args], days_alive: days_alive)
          command.created_at = DateTime.now
          command.expires_at = command.created_at + days_alive

          CommandRepository.create command
          handle_error
        end

        def get
          @command_object = CommandRepository.with_token(@token_presented)
          if @command_object == nil
            @error = 'command not found for token proffered'
            puts @error.red
            return @error
          end
          @command_verb = @command_object.command_verb
          @args = @command_object.args
          puts "get, command_verb: #{@command_verb}"
          puts "get, args: #{@args}"
          @error

        end

        def add_to_expires_at(n)
          command = get
          command.expires_at = command.expires_at + n
          CommandRepository.update command
        end

        def execute
          get
          return @error if @error
          if DateTime.now > @command_object.expires_at
            @error = 'token has expired'
            puts @error.red
            return @error
          end
          return @error if @error
          execute_command
          handle_error
        end

        def execute_command

          puts "execute_command".red
          puts "args #{@args}".cyan

          case @command_verb
            when 'add_group'
              ugm = UserGroupManager.new(@user)
              group = @args[0]
              ugm.add(group)
            when 'add_document'
              @user.node.append_doc(@args[0], 'standard')
            when 'add_document_to_group'
              ugm = UserGroupManager.new(@user)
              group = @args[0]
              ugm.add(group)
            when 'add_group_and_document'
              doc_id = @args[0]
              group = @args[1]
              @document = DocumentRepository.find doc_id
              @document.acl_set(:group, group, 'rw')
              DocumentRepository.update @document
            else
              @error = 'unrecognized command'
          end
          @error
        end

      end
    end
  end
end

