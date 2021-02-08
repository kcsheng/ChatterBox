require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: 'Example User', email: 'user@example.com',
                     password: 'foobar', password_confirmation: 'foobar')
  end
  
  test 'user should be valid' do
    assert @user.valid?
  end

  test 'name should be present' do
    @user.name = ' '
    assert_not @user.valid?
  end

  test 'email should be present' do
    @user.email = ' '
    assert_not @user.valid?
  end

  test 'name should not over 50 chars' do
    @user.name = 'a' * 51
    assert_not @user.valid?
  end

  test 'email should not over 255 chars' do
    @user.email = 'a' * 256
    assert_not @user.valid?
  end

  test 'email validation should accept valid addresses' do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |address|
      @user.email = address
      assert @user.valid?, "#{address.inspect} should be valid."
    end
  end

  test 'email validation should reject invalid email addresses' do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |address|
      @user.email = address
      assert_not @user.valid?, "#{address.inspect} should be invalid."
    end
  end

  test 'email address should be unique' do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test 'password should not be blank' do
    @user.password = @user.password_confirmation = ' ' * 6
    assert_not @user.valid?
  end

  test 'password should have a minimum length of 6' do
    @user.password = @user.password_confirmation = 'a' * 5
    assert_not @user.valid?
  end

  test 'authenticated? should return false if remember_digest is nil' do
    assert_not @user.authenticated?(:remember, '')
  end

  test 'assocated microposts should be destroyed' do
    @user.save
    @user.microposts.create!(content: 'Lorem Ipsum')
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  test 'should follow and unfollow a user' do
    eric = users(:eric)
    tom = users(:tom)
    eric.unfollow(tom)
    assert_not eric.following?(tom)
    eric.follow(tom)
    assert eric.following?(tom)
    assert tom.followers.include?(eric)
    eric.follow(eric)
    assert_not eric.following?(eric)
  end

  test 'should have the right posts' do
    eric = users(:eric)
    tom = users(:tom)
    jane = users(:jane)
    jane.microposts.each do |post|
      assert eric.feed.include?(post)
    end
    eric.microposts.each do |post|
      assert eric.feed.include?(post)
    end
    tom.microposts.each do |post|
      assert tom.feed.include?(post)
    end
    tom.microposts.each do |post|
      assert_not jane.feed.include?(post)
    end
  end
end
 