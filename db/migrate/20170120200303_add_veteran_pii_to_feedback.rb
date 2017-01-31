class AddVeteranPiiToFeedback < ActiveRecord::Migration
  def change
    add_column :feedback, :veteran_pii, :text
  end
end
