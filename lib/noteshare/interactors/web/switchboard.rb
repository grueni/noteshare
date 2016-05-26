require 'lotus/interactor'
require_relative '../../../../lib/ui/links'
require_relative '../../entities/ns_node'

module Noteshare
  module Interactor
    module Web


      class Switchboard

        include Lotus::Interactor
        include ::Noteshare::Core::Node
        include ::UI::Links


        expose :redirect_path

        def host_base
          http_host_parts = request.env['HTTP_HOST'].split('.')
          if http_host_parts[-1] =~ /localhost/
            return http_host_parts[-1]
          else
            return "#{http_host_parts[-2]}.#{http_host_parts[-1]}"
          end
        end


        # There are currently two values for the value of @node.type:
        # 'public' and 'personal'
        def handle_incoming_node

          puts "referer: #{@referer}".cyan

          if @incoming_node
            puts "@incoming_node: #{@incoming_node.name}".red
          else
            puts "No incoming node".red
          end

          if @user
            prefix = @user.screen_name
          else
            prefix = @incoming_node_name || :none
          end

          if @incoming_node
            if  @incoming_node.type == 'public'
              @redirect_path = basic_link prefix, "node/#{@incoming_node.id}"
            else
              @redirect_path = basic_link @incoming_node.name, "home"
            end
          else
            @redirect_path = basic_link :none, 'home'
          end

        end

        def initialize(hash)
          @user = hash[:user]
          @incoming_node = hash[:node]
          @incoming_node_name =  @incoming_node.name if @incoming_node
          @referer = hash[:referer]
        end

        def call
          handle_incoming_node
        end

      end

    end
  end
end

