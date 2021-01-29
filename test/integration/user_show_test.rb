require 'test_helper'

class UserShowTest < ActionDispatch::IntegrationTest
  def setup
    @unactivated_user = users(:unactivated)
    @activated_user = users(:tom)
  end

  test 'should redirect when user is not activated' do
    get user_path(@unactivated_user)
    assert_response :redirect
    assert_redirected_to root_url

    get user_path(@activated_user)
    assert_response :success
    assert_template 'users/show'
  end
end
