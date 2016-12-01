class ChangeApplicationColumnName < ActiveRecord::Migration
  def change
    rename_column :feedback, :application, :subject
  end
end
