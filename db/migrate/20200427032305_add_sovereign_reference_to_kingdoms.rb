# frozen_string_literal: true

class AddSovereignReferenceToKingdoms < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def change
    add_reference :kingdoms, :sovereign, index: { algorithm: :concurrently }
  end
end
