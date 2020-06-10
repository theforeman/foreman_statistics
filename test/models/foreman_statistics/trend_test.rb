require_relative '../../test_plugin_helper'

module ForemanStatistics
  class TrendTest < ActiveSupport::TestCase
    test 'should delete trend and associated trend counters' do
      trend = FactoryBot.create(:foreman_statistics_trend, :value, :with_counters)
      trend_id = trend.id
      assert_equal 2, TrendCounter.where(:trend_id => trend_id).length
      assert_difference('Trend.count', -1) do
        as_admin do
          trend.destroy
        end
      end
      assert_equal 0, TrendCounter.where(:trend_id => trend_id).length
    end

    test '#find hosts returns empty result if associated record does not exist' do
      trend = FactoryBot.build(:foreman_statistics_foreman_trend)
      assert_empty trend.find_hosts
    end
  end
end
