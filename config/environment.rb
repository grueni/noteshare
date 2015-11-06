require 'rubygems'
require 'bundler/setup'
require 'lotus/setup'
require_relative '../lib/noteshare'
require_relative '../apps/session_manager/application'
require_relative '../apps/mapper/application'
require_relative '../apps/admin/application'
require_relative '../apps/editor/application'
require_relative '../apps/web/application'
require_relative '../apps/node/application'

Lotus::Container.configure do
  mount SessionManager::Application, at: '/session_manager'
  mount Node::Application, at: '/node'
  mount Mapper::Application, at: '/mapper'
  mount Admin::Application, at: '/admin'
  mount Editor::Application, at: '/editor'
  mount Web::Application, at: '/'
end
