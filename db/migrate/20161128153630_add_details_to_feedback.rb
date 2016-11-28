class AddDetailsToFeedback < ActiveRecord::Migration
  def change
    add_column :feedback, :note, :text
    add_column :feedback, :status, :integer, default: 0
  end
end
