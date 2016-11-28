class AddContactEmailToFeedback < ActiveRecord::Migration
  def change
    add_column :feedback, :contact_email, :text
  end
end
