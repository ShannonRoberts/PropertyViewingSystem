class CreateProperties < ActiveRecord::Migration[6.1]
  def up
    create_table :properties do |t|
      t.string :title, null: false
      t.string :property_type, null: false
      t.string :status, null: false
      t.string :street_address, null: false
      t.string :suburb, null: false
      t.string :city, null: false
      t.string :region, null: false
      t.string :zip_code, null: false
      t.string :country, null: false
      t.text :description, null: false
      t.integer :price, null: false
      t.integer :bedrooms, null: false
      t.integer :bathrooms, null: false
      t.integer :square_feet
      t.integer :year_built
      t.decimal :lot_size, precision: 8, scale: 2
      t.references :property_manager, null: false, foreign_key: true

      t.timestamps
    end

    add_index :properties, :status
    add_index :properties, :property_type
    add_index :properties, :price
    add_index :properties, :suburb
    add_index :properties, :city
    add_index :properties, :region
    add_index :properties, :zip_code
  end

  def down
    drop_table :properties
  end
end
