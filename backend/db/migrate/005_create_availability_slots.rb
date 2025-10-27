class CreateAvailabilitySlots < ActiveRecord::Migration[6.1]
  def up
    create_table :availability_slots do |t|
      t.references :property, null: false, foreign_key: true
      t.references :property_manager, null: false, foreign_key: true
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false

      t.timestamps
    end

    add_index :availability_slots, :start_time
    add_index :availability_slots, :end_time
    add_index :availability_slots, [:property_id, :start_time]
    add_index :availability_slots, [:property_manager_id, :start_time]
  end

  def down
    drop_table :availability_slots
  end
end
