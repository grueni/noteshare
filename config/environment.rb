require 'rubygems'
require 'bundler/setup'
require 'lotus/setup'
require_relative '../lib/noteshare'
require_relative '../apps/admin/application'
require_relative '../apps/editor/application'
require_relative '../apps/web/application'

Lotus::Container.configure do
  mount Admin::Application, at: '/admin'
  mount Editor::Application, at: '/editor'
  mount Web::Application, at: '/'
end
