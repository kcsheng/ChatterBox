require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: '', 
                                         email: 'user@test.com', 
                                         password: 'foo', 
                                         password_confirmation: 'bar' } }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end

  test "valid signup with account activation" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: 'Example user', 
                                         email: 'user@example.com', 
                                         password: 'foobar', 
                                         password_confirmation: 'foobar' } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    log_in_as(user)
    assert_not is_logged_in? #sessions's helper logged_in? does not work
    get edit_account_activation_path('ivalid_token', email: user.email) #use path for test
    assert_not is_logged_in?
    get edit_account_activation_path(user.activation_token, email: 'wrong@mail.com')
    assert_not is_logged_in?
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated? #Reload user from database, instead of user in memory
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
end
