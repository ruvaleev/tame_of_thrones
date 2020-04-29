# frozen_string_literal: true

class GameSet < ApplicationRecord
  has_many :kingdoms, dependent: :destroy
  has_one :player, class_name: 'Kingdom', foreign_key: 'game_id', dependent: :destroy

  validates :uid, uniqueness: true
  validates :uid, presence: true
end
