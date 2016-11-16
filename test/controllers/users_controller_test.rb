require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  USER_LOGIN_ALLREADY_USED = 'allready_used_login'
  PASSWORD_OF_ALLREADY_USED_USER = 'sample_pass'
  

  setup do
    @user = User.create login: USER_LOGIN_ALLREADY_USED, password: Digest::MD5.hexdigest(PASSWORD_OF_ALLREADY_USED_USER)
  end

  #общий сценрий при котором пользователь не создаётся
  def user_should_not_create_with login, pass, confirm_pass
    assert_no_difference('User.count')do
      post users_url, params: { 
        user: { 
          login: login, 
          password: pass, 
          password_confirmation: confirm_pass 
        } 
      }
    end
  end

  #Для демонстрации
  test "should get index" do
    get users_url
    assert_response :success
  end

  test "should get new" do
    get new_user_url
    assert_response :success
  end

  test "should create user if confirmation match with password" do
  
    login = 'login_for_new_user'
    password = 'password_for_new_user'
    
    #Given:
    assert_nil User.find_by(login: login), "Given error: User with login:#{login} should not exist."
    
    #When:
    assert_difference('User.count') do
      post users_url, params: { 
        user: { 
          login: login, 
          password: password, 
          password_confirmation: password 
        } 
      }
    end

    #Then:
    created_user = User.last
    assert_redirected_to user_url(created_user)
    assert_equal login, created_user.login
  end

  test "should not create user if confirmation does not match with password" do
  
    login = 'login_for_new_user_bad_confirm'
    password = 'password_for_new_user'
    pass_confirmation = 'confirm_password_for_new_user'
    
    #Given:
    assert_nil User.find_by(login: login), "Given error: User with login:#{login} should not exist."
  
    #When:
    user_should_not_create_with login, password, pass_confirmation
  end


  test "should not create user if login allready exist" do
  
    login = USER_LOGIN_ALLREADY_USED
    password = 'password_for_new_user'
    pass_confirmation = 'confirm_password_for_new_user'
  
    #Given:
    assert !!User.find_by(login: login), "Given error: User with login:#{login} should exist."
    
    #When:
    user_should_not_create_with login, password, pass_confirmation
    
  end

  test "should show user" do
  
    p @user
    #Given:
    assert !!User.find_by(login: @user.login), "Given error: User with login:#{@user.login} should exist."
  
    get user_url(@user)
    assert_response :success
  end
end
