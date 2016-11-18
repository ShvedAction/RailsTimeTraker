require 'test_helper'

class TimeFlowTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  
  test "in one session a track should create for current user" do
    track = { 
      start_time: "2016-11-18T14:56:08+03:00",
      total_time: 3000,
      tag: "some tage",
      type_work: 1, #link to type work
    }
  
    user_session = build_some_user
    
    #get model from this session
    user = user_session.current_user
    assert_difference ->{user.tracks.count}, 1, "tracks count of user should increase by 1" do
      user_session.add_track track
    end
  end
  
  test "after sign up, user should be auth" do
    login = "new_login"
    password = "sapmplePassword"
    
    #Given:
    user_with_login_should_not_exist login, "Given error:"
    
    user_session = build_session_for_user login, password
    user_session.sign_up
    
    #Verify that user is auth, passes inside next method. See defenition
    user_session.should_success_sign_up
    
    user_session.should_out_login_in_tag 'span'
  end
  
  private 
  
    module UserSessionHelper
      def set_login_password login, password
        @login = login
        @password = password
      end
      
      def sign_up
        post "/users", params: {user: {login: @login, password: @password, password_confirmation: @password}}
      end
      
      def log_in
        post '/user/log_in', params: {user: {login: @login, password: @password}}
      end
      
      def add_track track_hash
        post "/users/#{current_user.id}/tracks", params: {track: track}
      end
      
      def should_success_logining message=""
        assert !!User.find_by(login: @login), "#{message} For success logining, user should be in database."
        assert_equal current_user.id, controller.session[:current_user_id], "#{message} For success logining, session should have user_id."
      end
      
      def should_success_sign_up message=""
        follow_redirect!
        should_success_logining message
      end
      
      def should_out_login_in_tag tag_name, message=""
        assert_select tag_name, @login, message
      end
      
      def current_user
        @current_user ||= User.find_by login: @login
      end
        
    end
    
    def build_session_for_user login, password, description_case = ""
      open_session do |sess|
        sess.extend(UserSessionHelper)
        sess.set_login_password login, password
      end
    end
    
    def build_some_user login="some_login", password="some_password"
      #Given:
      user_with_login_should_not_exist login, "Given error:"
      
      user = build_session_for_user login, password
      user.sign_up
      
      #follow redirect in this method
      user.should_success_sign_up
      
      return user
    end
end
