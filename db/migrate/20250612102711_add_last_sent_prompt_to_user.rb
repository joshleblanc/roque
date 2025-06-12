class AddLastSentPromptToUser < ActiveRecord::Migration[8.0]
  def change
    add_reference :users, :last_sent_prompt, null: false, foreign_key: { to_table: :prompts }, default: Prompt.last.id
  end
end
