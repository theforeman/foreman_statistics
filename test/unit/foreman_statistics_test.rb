require 'test_statistics_helper'

class ForemanStatisticsTest < ActiveSupport::TestCase
  setup do
    User.current = User.find_by login: 'admin'
  end

  test 'the truth' do
    assert true
  end
end
