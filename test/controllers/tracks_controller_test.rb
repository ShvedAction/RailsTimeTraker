require 'test_helper'

class TracksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @track = tracks(:one)
  end

  test "should get index" do
    get tracks_url
    assert_response :success
  end

  test "should get new" do
    get new_track_url
    assert_response :success
  end

  test "should create track" do
    assert_difference('Track.count') do
      post tracks_url, params: { track: { end_time: @track.end_time, start_time: @track.start_time, tag: @track.tag, total_time: @track.total_time, user_id: @track.user_id, work_type: @track.work_type } }
    end

    assert_redirected_to track_url(Track.last)
  end

  test "should show track" do
    get track_url(@track)
    assert_response :success
  end

  test "should get edit" do
    get edit_track_url(@track)
    assert_response :success
  end

  test "should update track" do
    patch track_url(@track), params: { track: { end_time: @track.end_time, start_time: @track.start_time, tag: @track.tag, total_time: @track.total_time, user_id: @track.user_id, work_type: @track.work_type } }
    assert_redirected_to track_url(@track)
  end

  test "should destroy track" do
    assert_difference('Track.count', -1) do
      delete track_url(@track)
    end

    assert_redirected_to tracks_url
  end
end
