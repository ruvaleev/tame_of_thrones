# frozen_string_literal: true

class AddGameSetReferenceToKingdoms < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def change
    add_reference :kingdoms, :game_set, index: { algorithm: :concurrently }
  end
end
