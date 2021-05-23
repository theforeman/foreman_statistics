class MigrateEnvironments < ActiveRecord::Migration[6.0]
  class FakeTrend < ApplicationRecord
    self.table_name = 'trends'
  end

  def up
    FakeTrend.where(trendable_type: 'Environment').update_all(trendable_type: 'ForemanPuppet::Environment')
  end

  def down
    FakeTrend.where(trendable_type: 'ForemanPuppet::Environment').update_all(trendable_type: 'Environment')
  end
end
