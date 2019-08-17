class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.text :body
      t.references :sender, foreign_key: { to_table: :kingdoms }
      t.references :receiver, foreign_key: { to_table: :kingdoms }
    end

    add_index :messages, [:sender_id, :receiver_id]
  end
end
