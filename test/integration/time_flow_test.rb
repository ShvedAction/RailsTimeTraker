require 'test_helper'

class TimeFlowTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  
  setup do
    @track_hash_example = { 
      start_time: "2016-11-18T14:56:08+03:00",
      total_time: 3000,
      tag: "some tage",
      work_type: 'developing', #link to type work
    }
  end
  
  test "create temp user when try add track" do
    assert_difference ->{User.count}, 1, "user count should increase" do
      assert_difference ->{Track.count}, 1, "track count should increase" do
        open_session do |sess|
          sess.extend(UserSessionHelper)
          
          sess.add_track @track_hash_example
          
          assert sess.current_user.temporary?, "user should be temp"
        end
      end
    end
  end
  
  test "in one session a track should create for current user" do
  
    user_session = build_some_user
    
    #get model from this session
    user = user_session.current_user
    assert_difference ->{user.tracks.count}, 1, "tracks count of user should increase by 1" do
      user_session.add_track @track_hash_example
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
