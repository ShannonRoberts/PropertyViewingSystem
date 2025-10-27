class CreatePotentialTenants < ActiveRecord::Migration[6.1]
  def up
    create_table :potential_tenants do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :phone, null: false

      t.timestamps
    end

    add_index :potential_tenants, :email, unique: true
  end

  def down
    drop_table :potential_tenants
  end
end
