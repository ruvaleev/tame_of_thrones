# frozen_string_literal: true

class CreateKingdoms < ActiveRecord::Migration[5.2]
  def change
    create_table :kingdoms do |t|
      t.string :name_en, unique: true
      t.string :name_ru, unique: true
      t.string :emblem_en, unique: true
      t.string :emblem_ru, unique: true
      t.string :leader_ru, unique: true
      t.string :leader_en, unique: true
      t.string :title_en, default: :King
      t.string :title_ru, default: :Король
      t.string :emblem_avatar
      t.string :leader_avatar
      t.boolean :ruler, default: false
      t.integer :vassals_count, default: 0
    end
  end
end
