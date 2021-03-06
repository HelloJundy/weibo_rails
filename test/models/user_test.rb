require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup            #setup方法會在測試方法运行前执行
    @user = User.new(name:"hello", email: "hello@123.com", password: "foobar", password_confirmation:"foobar");
  end
  
  test "should be valid" do
    assert @user.valid? 
  end
  
  test "name should be present" do
    @user.name = " "
    assert_not @user.valid?     #因为在models中做了验证，如果名字为空的话  user.valid?  返回值为 false
  end
  
  test "email should be present" do
    @user.email=" "
    assert_not @user.valid?
  end
  
  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end
  
  test "email should not be too long" do
    @user.email = "a" * 256
    assert_not @user.valid?
  end
  
  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
     @user.email = valid_address
     assert @user.valid? , "#{valid_address.inspect} should be valid"
    end
  end
  
  test "email validation should reject invalid addresses" do
    valid_addresses = %w[user@example,com user_at_foo.org user.name@example.foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert_not @user.valid?, "#{valid_address.inspect} should be invalid"
    end
  end
  
  test "email addresses should be saved as low-case" do
    valid_address = "hellojund@163.com"
    @user.email = valid_address.upcase
    @user.save
    assert_equal valid_address.downcase, @user.reload.email
  end
  
  test "email addresses should be unique" do
    dup_user =  @user.dup
    @user.save
    dup_user.email= @user.email.upcase
    assert_not dup_user.valid?
  end
  
  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5;
    assert_not @user.valid?
  end
  
  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end
  
  test "associated microposts should be destroy" do
    @user.save
    @user.microposts.create!(content:"hello")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end
  test "should follow and unfollow a user " do
    admin = users(:admin)
    archer = users(:archer)
    assert_not admin.following?(archer)
    admin.follow(archer)
    assert admin.following?(archer)
    assert archer.followers.include?(admin)
    admin.unfollow(archer)
    assert_not admin.following?(archer)
  end
  
 test "feed should have the right posts" do
    michael = users(:michael)
    archer = users(:archer)
    lana = users(:lana)
    
    lana.microposts.each do |post_following|
      assert michael.feed.include?(post_following)
    end
    
    michael.microposts.each do |post_self|
      assert michael.feed.include?(post_self)
    end
    archer.microposts.each do |post_unfollowed|
      assert_not michael.feed.include?(post_unfollowed)
    end
 end
end
    