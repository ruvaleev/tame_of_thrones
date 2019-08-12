class CreateKingdoms < ActiveRecord::Migration[5.2]
  def change
    create_table :kingdoms do |t|
      t.string :name, unique: true, index: true
      t.boolean :ruler, default: false
    end
  end
end
