require "test_helper"

class TestsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get tests_index_url
    assert_response :success
  end

  test "should get generate" do
    get tests_generate_url
    assert_response :success
  end
end
