# frozen_string_literal: true

class AddGameReferenceToKingdoms < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def change
    add_reference :kingdoms, :game, index: { algorithm: :concurrently }
  end
end
