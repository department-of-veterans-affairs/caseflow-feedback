class CreateAdmins < ActiveRecord::Migration
  def change
    create_table :admins do |t|
      t.string :css_id, null: false
    end

    add_index :admins, :css_id, unique: true
  end
end
