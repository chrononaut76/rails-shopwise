require "test_helper"

class UserItemsControllerTest < ActionDispatch::IntegrationTest
  test "should get stores" do
    get user_items_stores_url
    assert_response :success
  end
end
