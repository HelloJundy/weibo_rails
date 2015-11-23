require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  get signup_path

  assert_no_difference 'User.count' do
    post users_path, user:{ name:"",
                            email: "user@invalid",
                            password:              "foo",
                            password_confirmation: "bar"}
  end
end
