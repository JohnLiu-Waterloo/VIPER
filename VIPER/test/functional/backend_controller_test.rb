require 'test_helper'

class BackendControllerTest < ActionController::TestCase
  test "should get clusterUsers" do
    get :clusterUsers
    assert_response :success
  end

  test "should get findFriends" do
    get :findFriends
    assert_response :success
  end

  test "should get getRecommendation" do
    get :getRecommendation
    assert_response :success
  end

end
