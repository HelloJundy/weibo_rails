require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
 
  test "invalid signup imformation" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user:{ name:"",
                              email: "user@invalid",
                              password:              "foo",
                              password_confirmation: "bar"}
    end
    assert_template "users/new"
    #assert_select 'div#<CSS id for error explanation>'
    #assert_select 'div.<CSS class for field with error>'
  end
  
  test "valid signup imformation" do
    get signup_path
    name = "User"
    email = "abc@abc.com"
    password = "123456"
    password_confirmation = "123456"
    assert_difference 'User.count',1 do 
      post_via_redirect users_path, user:{ name: name,
                             email: email,
                             password: password,
                             password_confirmation: password_confirmation
      }
    end
    assert_template "users/show"
    assert is_log_in?
    assert_not flash.nil?
  end
end
