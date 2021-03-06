require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  
  def setup
    @user =  users(:admin)
  end
  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, session:{email:"", password:""}
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
  
  test 'login with valid information' do
    get login_path
    post login_path, session:{ email:@user.email, password: 'password' }
    assert_redirected_to @user  #检查重定向的地址是否正确
    follow_redirect!  #访问重定向的目标地址
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", user_path(@user)
    assert_select "a[href=?]", logout_path
    delete logout_path
    assert_not is_log_in?
    assert_redirected_to root_url
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", user_path(@user), count:0
    assert_select "a[href=?]", logout_path, count:0
  end
  
  test 'login with remember' do
    log_in_as(@user)
    # assigns(:user).remember_token, cookies['remember_token']
    assert_not_nil cookies['remember_token']
  end
  
  test 'login without remember' do
    log_in_as(@user, remember_me: '0')
    assert_nil cookies['remember_token']   #测试中cookies不能使用符号键，所以在这里使用字符串关键字
  end
end
