require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  test "should not save if confirmation_password does not mach password" do
    login = "login_for_incorrect_password"
    
    #Given:
    assert_nil User.find_by(login: login), "Given error: User with login #{login} should not exist."
    
    new_user = User.new login: login, password: "samplePassword", password_confirmation:"incorrectConfirm"
    
    #When:
    assert_raises ActiveRecord::RecordInvalid, "User with incorrect confirmation password have saved." do
      new_user.registration!
    end
    
    #Then:
    assert_nil User.find_by(login: login), "User with incorrect confirmation password have found."
  end
  
  test "should save if confirmation_password mach password" do
    login = "no_exist_login"
    password = "correctPassword"
    
    #Given:
    assert_nil User.find_by(login: login), "Given error: User with login #{login} should not exist."
    
    new_user = User.new login: login, password: password, password_confirmation: password
    
    #When:
    assert_difference 'User.count', 1, "User with correct confirmation password should saved." do
      new_user.registration!
    end
    
    #Then:
    assert !!User.find_by(login: login), "User with correct confirmation password should found."
  end
  
  test "should save without password if his auth_type is temp_user" do
  
    temp_user = User.new auth_type: 'temporary'
    
    #When:
    assert_difference 'User.count', 1, "Temp user should saved." do
      temp_user.save
    end
    
    #Then:
    refute_empty temp_user.login, "Temp user should have unic login"
  end
  
  test "on new User should auth_type init with deffault auth_type is registred" do
    new_user = User.new
    
    assert new_user.registred?, "default auth_type should be registred"
  end
  
  test "after registration new user, class method 'log_in' should return user if hash of password and login match record in DB" do
    login = "model_try_login"
    password = "sample_password"
    
    #Given:
    assert_nil User.find_by(login: login), "Given error: User with login #{login} should not exist."
    
    user = User.new login: login, password: password, password_confirmation: password
    user.registration!
    
    #When:
    logining_user = User.log_in({login: login, password: password})
    
    #Then:
    assert !!logining_user, "retunred value from method log_in should not be nil"
    assert !!logining_user.id, "id user should not be nil"
    assert_equal login, logining_user.login
  end
  
  test "class method log_in shoul return nil if wrong password" do
    login = "model_try_login"
    true_password = "sample_password"
    wron_password = "wrong_password"
    
    #Given:
    assert_nil User.find_by(login: login), "Given error: User with login #{login} should not exist."
    
    user = User.new login: login, password: true_password, password_confirmation: true_password
    user.registration!
    
    #When:
    logining_user = User.log_in({login: login, password: wron_password})
    
    #Then:
    assert_nil logining_user
  end
  
  
  test "class method create_temp should save user with no empty login" do  
  
    assert_difference -> {User.count}, 1, "user count should increase" do
      temp_user = User.create_temp
      refute_empty temp_user.login, "login of temp user should not be empty"
    end
    
  end
end
