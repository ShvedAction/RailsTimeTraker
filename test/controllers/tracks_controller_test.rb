require 'test_helper'

class TracksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @track = tracks(:one)
    @user = users(:one)
  end

  test "should get index" do
    get user_tracks_url(@track.user, @track)
    assert_response :success
  end

  test "should get new for current user" do
    get new_user_track_url(@user)
    assert_response :success
  end

  test "should create track" do
  
    assert_difference ->{@user.tracks.count}, 1 do
      post user_tracks_url(@user), params: { track: { end_time: @track.end_time, start_time: @track.start_time, tag: @track.tag, total_time: @track.total_time, work_type: @track.work_type } }
    end

    assert_redirected_to user_tracks_url(@user)
  end

  test "should get edit" do
    get edit_user_track_url(@track.user, @track)
    assert_response :success
  end

  test "should update track" do
    patch user_track_url(@track.user, @track), params: { track: { end_time: @track.end_time, start_time: @track.start_time, tag: @track.tag, total_time: @track.total_time, user_id: @track.user_id, work_type: @track.work_type } }
    assert_redirected_to user_tracks_url(@user)
  end

  test "should destroy track" do
    assert_difference('Track.count', -1) do
      delete user_track_url(@track.user, @track)
    end

    follow_redirect!
  end
end
