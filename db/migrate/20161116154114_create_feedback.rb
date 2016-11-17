class CreateFeedback < ActiveRecord::Migration
  def change
    create_table :feedback do |t|
      t.string :application
      t.string :username
      t.text :feedback

      t.timestamps null: false
    end
  end
end
