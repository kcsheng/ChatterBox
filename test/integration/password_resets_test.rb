require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:eric)
  end

  test 'password resets' do
    get password_resets_new_path
    assert_template 'password_resets/new'
    assert_select 'input[name=?]', 'password_reset[email]'
    # Invalid email
    post password_resets_path, params: { password_reset: { email: '' } }
    assert_not flash.empty?
    assert_template 'password_resets/new'
    # Valid mail
    post password_resets_path, params: { password_reset: { email: @user.email }}
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
    # Password resert form
    user = assigns(:user)
    # Wrong email
    get edit_password_reset_path(user.reset_token, email: '')
    assert_redirected_to root_url
    # Inactive user
    user.toggle!(:activated)    
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    # Active user
    user.toggle!(:activated)    
    # Right email, wrong token
    get edit_password_reset_path('random_token', email: user.email)
    assert_redirected_to root_url
    # Right email, right token
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select 'input[name=email][type=hidden][value=?]', user.email
    # Invalid password and confirmation
    patch password_reset_path(user.reset_token), params: { email: user.email, 
                                                           user: { password: 'foobaz',
                                                                   password_confirmation: 'bazfoo' } }
    assert_select 'div#error_explanation'
    # Empty password
    patch password_reset_path(user.reset_token), params: { email: user.email, 
                                                           user: { password: '',
                                                                   password_confirmation: '' } }
    assert_select 'div#error_explanation'
    # Valid password and confirmation
    patch password_reset_path(user.reset_token), params: { email: user.email,
                                                           user: { password: 'password',
                                                                   password_confirmation: 'password' } }
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to user
    user.reload
    assert_nil user.reset_digest
  end

  test 'expired password reset' do
    get new_password_reset_path 
    post password_resets_path, params: { password_reset: { email: @user.email } }

    @user = assigns(:user)
    @user.update_attribute(:reset_sent_at, 3.hours.ago)
    patch password_reset_path(@user.reset_token), params: { email: @user.email,
                                                            user: { password: 'password',
                                                                    password_confirmation: 'password' } }
    assert_response :redirect
    follow_redirect!
    assert_match /expired/i, response.body
  end
end
