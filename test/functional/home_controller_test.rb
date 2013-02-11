require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get recommend" do
    get :recommend
    assert_response :success
  end

  test "should get info" do
    get :info
    assert_response :success
  end

end
