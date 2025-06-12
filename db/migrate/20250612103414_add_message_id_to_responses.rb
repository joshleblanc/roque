class AddMessageIdToResponses < ActiveRecord::Migration[8.0]
  def change
    add_column :responses, :message_id, :string
    add_index :responses, :message_id
  end
end
