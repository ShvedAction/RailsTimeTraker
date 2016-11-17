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
    assert_no_difference 'User.count', "User with incorrect confirmation password have saved." do
      new_user.save
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
    assert_difference 'User.count', "User with correct confirmation password should saved." do
      new_user.save
    end
    
    #Then:
    assert !!User.find_by(login: login), "User with correct confirmation password should found."
  end
end
