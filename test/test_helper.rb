ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'user_session_helper'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  
  def user_with_login_should_exist login, message = ""
    assert !!User.find_by(login: login), "#{message} User with login: #{login} should exist."
  end
  
  def user_with_login_should_not_exist login, message = ""
    assert_nil User.find_by(login: login), "#{message} User with login: #{login} should not exist."
  end
  
  def build_session_for_user login, password, description_case = ""
    open_session do |sess|
      sess.extend(UserSessionHelper)
      sess.set_login_password login, password
    end
  end
  
end
