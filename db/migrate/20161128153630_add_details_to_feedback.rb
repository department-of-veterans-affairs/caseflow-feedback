class AddDetailsToFeedback < ActiveRecord::Migration
  def change
    add_column :feedback, :admin_note, :text
    add_column :feedback, :status, :integer, default: 0
  end
end
