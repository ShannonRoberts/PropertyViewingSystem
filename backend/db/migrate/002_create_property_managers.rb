class CreatePropertyManagers < ActiveRecord::Migration[6.1]
  def up
    create_table :property_managers do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :phone, null: false
      t.string :company_name
      t.string :address
      t.boolean :active, default: true, null: false

      t.timestamps
    end

    add_index :property_managers, :email, unique: true
  end

  def down
    drop_table :property_managers
  end
end
