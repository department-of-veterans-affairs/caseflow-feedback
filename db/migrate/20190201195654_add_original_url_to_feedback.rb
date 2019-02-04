class AddOriginalUrlToFeedback < ActiveRecord::Migration[5.1]
  def change
    add_column :feedback, :original_url, :string
  end
end
