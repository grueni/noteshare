# Require this file for feature tests
require_relative './spec_helper'

require 'capybara'
require 'capybara/dsl'
require_relative '../lib/noteshare/modules/subdomain'

Capybara.app = Lotus::Container.new

class MiniTest::Spec
  include Capybara::DSL
end

module FeatureHelpers

  module Session
    def sign_in(email, password)
      visit '/session_manager/login'

      within 'form#user-form' do
        fill_in 'Email',  with: email
        fill_in 'Password', with: password
        click_button 'Log in'
      end

    end
  end

  module Common

    include ::Noteshare::Core::Document
    include Noteshare::Subdomain

    def visit2(user, route)
      if user
        visit "http://jxxmbp.local/#{route}"
      else
        visit "http://jxxmbp.local/#{route}"
      end
    end

    def standard_user_node_doc
      @user = User.create(first_name: 'Jared', last_name: 'Foo-Bar', email: 'jayfoo@bar.com',
                          screen_name: 'jayfoo', password: 'foobar123', password_confirmation: 'foobar123')
      NSNode.create_for_user(@user)
      @document = NSDocument.create(title: 'Test', author_credentials: @user.credentials)
      @document.acl_set_permissions('rw', 'r', 'r')
      DocumentRepository.update @document
    end

    def admin_user_node_doc
      @user = User.create(first_name: 'Jared', last_name: 'Foo-Bar', email: 'jayfoo@bar.com', admin: true,
                          screen_name: 'jayfoo', password: 'foobar123', password_confirmation: 'foobar123')
      NSNode.create_for_user(@user)
      @document = NSDocument.create(title: 'Test', author_credentials: @user.credentials)
      @document.acl_set_permissions('rw', 'r', 'r')
      DocumentRepository.update @document
    end

    def login_standard_user
      visit2 nil,  '/session_manager/login'

      within 'form#user-form' do
        fill_in 'Email',  with: 'jayfoo@bar.com'
        fill_in 'Password', with: 'foobar123'
        click_button 'Log in'
      end

      # visit2 @user, "/node/user/#{@user.id}"
      # assert page.has_content?(@user.screen_name), "Go to user's node page"
      #  @user
    end

  end
end