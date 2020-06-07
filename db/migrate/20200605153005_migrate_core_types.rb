class MigrateCoreTypes < ActiveRecord::Migration[6.0]
  def up
    Permission.where(:resource_type => 'Trend').update_all(:resource_type => 'ForemanStatistics::Trend')
    %w[ForemanTrend FactTrend Trend].each do |t|
      Trend.where(:type => t).update_all(:type => "ForemanStatistics::#{t}")
    end
  end

  def down
    Permission.where(:resource_type => 'ForemanStatistics::Trend').update_all(:resource_type => 'Trend')
    %w[ForemanTrend FactTrend Trend].each do |t|
      Trend.where(:type => "ForemanStatistics::#{t}").update_all(:type => t)
    end
  end
end
