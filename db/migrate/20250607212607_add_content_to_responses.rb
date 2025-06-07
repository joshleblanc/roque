class AddContentToResponses < ActiveRecord::Migration[8.0]
  def change
    add_column :responses, :content, :text
  end
end
