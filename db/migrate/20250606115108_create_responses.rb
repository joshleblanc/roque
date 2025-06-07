class CreateResponses < ActiveRecord::Migration[8.0]
  def change
    create_table :responses do |t|
      t.belongs_to :prompt, null: false, foreign_key: true
      t.string :discord_uid
      t.binary :embedding

      t.timestamps
    end
    add_index :responses, :discord_uid
  end
end
