class CreateAlliances < ActiveRecord::Migration[5.2]
  def change
    create_table :alliances do |t|
      t.belongs_to :sovereign
      t.belongs_to :vassal
    end
  end
end
