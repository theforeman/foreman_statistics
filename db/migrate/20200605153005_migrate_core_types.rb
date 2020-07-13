class MigrateCoreTypes < ActiveRecord::Migration[6.0]
  class FakeTrend < ApplicationRecord
    self.table_name = 'trends'
  end

  def up
    Permission.where(:resource_type => 'Trend').update_all(:resource_type => 'ForemanStatistics::Trend')
    %w[ForemanTrend FactTrend Trend].each do |t|
      FakeTrend.where(:type => t).update_all(:type => "ForemanStatistics::#{t}")
    end
  end

  def down
    Permission.where(:resource_type => 'ForemanStatistics::Trend').update_all(:resource_type => 'Trend')
    %w[ForemanTrend FactTrend Trend].each do |t|
      FakeTrend.where(:type => "ForemanStatistics::#{t}").update_all(:type => t)
    end
  end
end
