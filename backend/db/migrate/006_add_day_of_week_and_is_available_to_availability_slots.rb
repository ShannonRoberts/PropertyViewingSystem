class AddDayOfWeekAndIsAvailableToAvailabilitySlots < ActiveRecord::Migration[6.1]
  def up
    add_column :availability_slots, :day_of_week, :string
    add_column :availability_slots, :is_available, :boolean, default: true, null: false

    add_index :availability_slots, :day_of_week
    add_index :availability_slots, :is_available
  end

  def down
    remove_index :availability_slots, :day_of_week
    remove_index :availability_slots, :is_available
    remove_column :availability_slots, :day_of_week
    remove_column :availability_slots, :is_available
  end
end
