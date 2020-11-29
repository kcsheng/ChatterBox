require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  test 'application layout links' do
    get root_path
    assert_template 'static_pages/home'
    assert_select 'a[href=?]', root_path, count: 2
    assert_select 'a[href=?]', about_path
    assert_select 'a[href=?]', help_path
    assert_select 'a[href=?]', contact_path
    assert_select 'a[href=?]', login_path

    get signup_path
    assert_template 'users/new'
    assert_select 'title', generate_title('Sign up')

    user = users(:eric)
    log_in_as(user)
    get root_path
    assert_select 'a[href=?]', logout_path
    assert_select 'a[href=?]', users_path
    assert_select 'a[href=?]', user_path(user)
    assert_select 'a[href=?]', edit_user_path(user)
  end
end
