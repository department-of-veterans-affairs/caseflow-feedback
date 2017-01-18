class AddGithubUrlToFeedback < ActiveRecord::Migration
  def change
    add_column :feedback, :github_url, :string
  end
end
