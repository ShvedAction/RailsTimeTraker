require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  USER_LOGIN_ALLREADY_USED = 'allready_used_login'
  PASSWORD_OF_ALLREADY_USED_USER = 'sample_pass'
  

  setup do
    @user = User.create login: USER_LOGIN_ALLREADY_USED, password: password_encrypt_method(PASSWORD_OF_ALLREADY_USED_USER)
  end
  
  def password_encrypt_method pass
    return Digest::MD5.hexdigest pass
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
  
    #Given:
    assert !!@user, "Given error: User with login:#{@user.login} should exist."
  
    get user_url(@user)
    assert_response :success
  end
  
  test "after log in session should had user_id" do
    login = USER_LOGIN_ALLREADY_USED
    password = PASSWORD_OF_ALLREADY_USED_USER
    password_hash = password_encrypt_method password
    
    #Given:
    user = User.find_by(login: login)
    assert !!user, "Given error: User with login:#{login} should exist."
    assert_equal password_hash, user.password, "Given error: User with login:#{login} should have correct hash of password."
    
    #When:
    post user_log_in_url, params: {user: {login: login, password: password}}
    
    #Then:
    assert_response :success
    assert_equal user.id, session[:current_user_id]
  end
end
