# Require this file for feature tests
require_relative './spec_helper'

require 'capybara'
require 'capybara/dsl'

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
    def standard_user_node_doc
      @user = User.create(first_name: 'Jared', last_name: 'Foo-Bar', email: 'jayfoo@bar.com',
                          screen_name: 'jayfoo', password: 'foobar123', password_confirmation: 'foobar123')

      NSNode.create_for_user(@user)
      @document = NSDocument.create(title: 'Test', author_credentials: @user.credentials)
    end

  end
end