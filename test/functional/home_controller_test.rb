require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  test "should get login" do
    get :login
    assert_response :success
  end

  test "should get timeline" do
    get :timeline
    assert_response :success
  end

end
