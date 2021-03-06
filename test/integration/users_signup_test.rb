require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
 
 
  def setup
    ActionMailer::Base.deliveries.clear
  end
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
  
  test "valid signup imformation with account activation" do
    get signup_path
    name = "User"
    email = "abc@abc.com"
    password = "123456"
    password_confirmation = "123456"
    assert_difference 'User.count',1 do 
      post users_path, user:{ name: name,
                             email: email,
                             password: password,
                             password_confirmation: password_confirmation
      }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    #激活前 尝试登陆
    log_in_as(user)
    assert_not is_log_in?
    #激活令牌無效
    get edit_account_activation_path("invalid token")
    assert_not is_log_in?
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_log_in?
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_log_in?
        #assert_template "users/show"
    #assert is_log_in?
    #assert_not flash.nil?
  end
end
