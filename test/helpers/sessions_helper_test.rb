require 'test_helper'

class SessionsHelperTest < ActionView::TestCase
  def setup
    @user = users(:eric)
    remember(@user)
  end

  test 'current user is user while session is empty' do
    assert_equal @user, current_user
    assert logged_in?
  end

  test 'current user is nil when remember digest is wrong' do
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil current_user
  end
end