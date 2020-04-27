# frozen_string_literal: true

# Creating kingdoms
class ReinitializeKingdoms
  AVATARS_TITLES = {
    1 => :king,
    2 => :queen,
    3 => :king,
    4 => :king,
    5 => :king,
    6 => :queen
  }.freeze

  class << self
    def run
      Kingdom.destroy_all
      king_avatars = [1, 2, 3, 4, 5, 6].shuffle
      Kingdom::GREAT_HOUSES.each { |kingdom| create_kingdom(kingdom, king_avatars.pop) }
    end

    private

    def create_kingdom(kingdom, avatar) # rubocop:disable Metrics/MethodLength
      title = AVATARS_TITLES[avatar]
      names = ChooseName.new(title).run
      Kingdom.create(name_en: kingdom[:name_en],
                     name_ru: kingdom[:name_ru],
                     emblem_en: kingdom[:emblem_en],
                     emblem_ru: kingdom[:emblem_ru],
                     leader_en: names[:en],
                     leader_ru: names[:ru],
                     leader_avatar: "king_avatars/#{avatar}.png",
                     emblem_avatar: "emblem_avatars/#{kingdom[:name_en].downcase}.png",
                     title: title)
    end
  end
end
