class AddRetryCountToPrompts < ActiveRecord::Migration[8.0]
  def change
    add_column :prompts, :retry_count, :integer, default: 0
  end
end
