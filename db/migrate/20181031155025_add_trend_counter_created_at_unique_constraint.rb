class AddTrendCounterCreatedAtUniqueConstraint < ActiveRecord::Migration[6.0]
  def up
    add_index :trend_counters, %i[trend_id created_at], unique: true
  end

  def down
    remove_index :trend_counters, %i[trend_id created_at]
  end
end
