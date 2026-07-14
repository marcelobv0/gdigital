class CreateProjects < ActiveRecord::Migration[8.1]
  def change
    create_table :projects do |t|
      t.string :title, null: false
      t.string :status, null: false, default: "active"
      t.references :client, null: false, foreign_key: true

      t.timestamps
    end
    add_index :projects, :status
  end
end
