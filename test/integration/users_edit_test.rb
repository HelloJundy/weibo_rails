require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:admin)
  end
 
  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    patch user_path(@user), user:{ name: "",
                                   email: "foo@invalid",
                                   password: "foo",
                                   password_confirmation: "foo" }
    assert_template "users/edit"
  end
  
  test "successful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    name = "world"
    email = "foo@invalid.com"
    patch user_path(@user), user:{ name: name,
                                   email: email,
                                   password: "",
                                   password_confirmation: ""}
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal @user.name, name
    assert_equal @user.email, email
  end
  
  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    name = "bar"
    email = "foo@bar.com"
    patch user_path(@user), user: { name: name,
                                    email: email,
                                    password: "foobar",
                                    password_confirmation: "foobar" }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal @user.name, name
    assert_equal @user.email, email
  end
end
