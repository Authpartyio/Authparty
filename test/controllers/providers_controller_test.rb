require 'test_helper'

class ProvidersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get providers_index_url
    assert_response :success
  end

  test "should get new" do
    get providers_new_url
    assert_response :success
  end

  test "should get create" do
    get providers_create_url
    assert_response :success
  end

  test "should get show" do
    get providers_show_url
    assert_response :success
  end

  test "should get authenticate" do
    get providers_authenticate_url
    assert_response :success
  end

end
