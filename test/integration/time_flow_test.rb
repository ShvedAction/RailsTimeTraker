require 'test_helper'

class TimeFlowTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  
  test "in one session a track should create for current user" do
    
  end
  
  test "after sign up, user is auth" do
    login = "new_login"
    password = "sapmplePassword"
    
    #Given:
    user_with_login_should_not_exist login, "Given error:"
    
    user_session = sign_up login, password
    user_session.should_out_login_in_tag 'span'
  end
  
  private 
  
    module UserSessionHelper
      attr_accessor :current_user_login
      def should_out_login_in_tag tag_name
        assert_select tag_name, current_user_login
      end
    end
    
    def sign_up login, password, description_case = ""
      open_session do |sess|
        sess.extend(UserSessionHelper)
        sess.current_user_login = login
        sess.post "/users", params: {user: {login: login, password: password, password_confirmation: password}}
        
        sess.follow_redirect!
      end
    end
end
