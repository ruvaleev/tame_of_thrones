class Kingdom < ApplicationRecord
  has_many :alliances
  has_many :sovereigns, as: :vassal, through: :alliances
  has_many :vassals, as: :sovereign, through: :alliances

  def invite_to_alliance
    # Рассылаем приглашение в альянс
  end

  def consider_invitation
    # Рассматриваем приглашение
  end
end
