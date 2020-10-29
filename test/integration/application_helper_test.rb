require 'test_helper'

class ApplicationHelperTest < ActionDispatch::IntegrationTest
  test "title generator helper" do
    assert_equal 'ChatterBox', generate_title
    assert_equal 'About | ChatterBox', generate_title('About')
  end
end
