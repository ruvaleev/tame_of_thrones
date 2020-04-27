# frozen_string_literal: true

# Creating kingdoms
class ReinitializeKingdoms
  AVATARS_TITLES = {
    1 => %i[king король],
    2 => %i[queen королева],
    3 => %i[king король],
    4 => %i[king король],
    5 => %i[king король],
    6 => %i[queen королева]
  }.freeze

  class << self
    def run
      Kingdom.destroy_all
      king_avatars = [1, 2, 3, 4, 5, 6].shuffle
      Kingdom::GREAT_HOUSES.each { |kingdom| create_kingdom(kingdom, king_avatars.pop) }
    end

    private

    def create_kingdom(kingdom, avatar)
      title = AVATARS_TITLES[avatar]
      names = ChooseName.new(title.first).run
      Kingdom.create(kingdoms_params(kingdom, avatar, title, names))
    end

    def kingdoms_params(kingdom, avatar, title, names)
      { name_en: kingdom[:name_en],
        name_ru: kingdom[:name_ru],
        emblem_en: kingdom[:emblem_en],
        emblem_ru: kingdom[:emblem_ru],
        leader_en: names[:en],
        leader_ru: names[:ru],
        leader_avatar: "king_avatars/#{avatar}.png",
        emblem_avatar: "emblem_avatars/#{kingdom[:name_en].downcase}.png",
        title_en: title.first.capitalize,
        title_ru: title.last.capitalize }
    end
  end
end
