# frozen_string_literal: true

class ChooseEmblem
  attr_accessor :game_set_id

  EMBLEMS = [
    { emblem_en: 'Gorilla', emblem_ru: 'Горилла' },
    { emblem_en: 'Panda', emblem_ru: 'Панда' },
    { emblem_en: 'Octopus', emblem_ru: 'Осьминог' },
    { emblem_en: 'Mammoth', emblem_ru: 'Маммонт' },
    { emblem_en: 'Owl', emblem_ru: 'Сова' },
    { emblem_en: 'Dragon', emblem_ru: 'Дракон' }
  ].freeze

  def initialize(game_set_id)
    @game_set_id = game_set_id
  end

  def run
    emblems = find_uniq_emblems
    { ru: emblems[:emblem_ru], en: emblems[:emblem_en] }
  end

  private

  def find_uniq_emblems
    loop do
      emblems = EMBLEMS.sample
      break emblems if Kingdom.find_by(emblem_en: emblems[:emblem_en], game_set_id: game_set_id).nil?
    end
  end
end
