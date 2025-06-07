class AddCurrentToPrompts < ActiveRecord::Migration[8.0]
  def change
    add_column :prompts, :current, :boolean
  end
end
