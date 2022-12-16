class AddRangeToTrendCounters < ActiveRecord::Migration[6.0]
  def change
    add_column :trend_counters, :interval_start, :datetime
    add_column :trend_counters, :interval_end, :datetime
  end
end
