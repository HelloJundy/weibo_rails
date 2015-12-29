require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:admin)
  end
  
  test "microposts sidebar count" do 
    log_in_as(@user)
    get root_path
    assert_match "#{@user.microposts.count} microposts", response.body
    
    #用戶沒有發微博
    other_user = users(:mallory)
    log_in_as(other_user)
    get root_path
    assert_match "0 microposts", response.body
    other_user.microposts.create!(content: "A micropost")
    get root_path
    assert_match "1 micropost",response.body
  end
end
