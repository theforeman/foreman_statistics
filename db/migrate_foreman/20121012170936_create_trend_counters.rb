class CreateTrendCounters < ActiveRecord::Migration[6.0]
  def up
    create_table :trend_counters do |t|
      t.references :trend, foreign_key: true
      t.integer :count

      t.timestamps null: true
    end
  end

  def down
    drop_table :trend_counters
  end
end
