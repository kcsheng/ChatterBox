require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users(:eric)
    @micropost = @user.microposts.build(content: 'Lorem Ipsum')
  end

  test 'should be valid' do
    assert @micropost.valid?
  end

  test 'user id should be present' do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test 'content should be present' do
    @micropost.content = ' '
    assert_not @micropost.valid?
  end

  test 'content should be no more than 140 characters' do
    @micropost.content = 'a' * 141
    assert_not @micropost.valid?
  end

  test 'order should be the most rencet first' do
    assert_equal microposts(:most_recent), Micropost.first
  end
end
