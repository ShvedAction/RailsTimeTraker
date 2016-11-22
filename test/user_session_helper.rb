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
    post "/tracks", params: {track: track_hash}
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
    @current_user ||= User.find session[:current_user_id]
  end
end

