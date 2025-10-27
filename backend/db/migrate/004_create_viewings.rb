class CreateViewings < ActiveRecord::Migration[6.1]
  def up
    create_table :viewings do |t|
      t.datetime :scheduled_at, null: false
      t.string :status, null: false
      t.text :notes
      t.references :property, null: false, foreign_key: true
      t.references :potential_tenant, null: false, foreign_key: true

      t.timestamps
    end

    add_index :viewings, :scheduled_at
    add_index :viewings, :status
  end

  def down
    drop_table :viewings
  end
end
