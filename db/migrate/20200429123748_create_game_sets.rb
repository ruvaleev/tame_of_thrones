# frozen_string_literal: true

class CreateGameSets < ActiveRecord::Migration[5.2]
  def change
    create_table :game_sets do |t|
      t.string :uid, unique: true
      t.datetime :end_at

      t.timestamps
    end
  end
end
