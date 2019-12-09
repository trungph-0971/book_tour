require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup information" do
    get signup_path
    assert_no_difference "User.count" do
      post users_path, params: { user: { name: "",
                                         email: "user@invalid",
                                         phone_number: "0903113115123",
                                         password: "foo",
                                         password_confirmation: "bar" } }
    end
  end

  test "valid signup information" do
    get signup_path
    assert_difference "User.count", 1 do
      post users_path, params: { user: { name: "Example User",
                                         email: "user@example.com",
                                         phone_number: "0903113115",
                                         password: "password",
                                         password_confirmation: "password" } }
    end
    follow_redirect!
  end
end
