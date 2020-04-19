# frozen_string_literal: true

# Creating kingdoms
class ReinitializeKingdoms
  def self.run
    Kingdom.destroy_all

    king_avatars = [1, 2, 3, 4, 5, 6].shuffle
    Kingdom::GREAT_HOUSES.each do |kingdom|
      Kingdom.create(name: kingdom[:name],
                     emblem: kingdom[:emblem],
                     king: kingdom[:king] || FFaker::Name.first_name,
                     emblem_avatar: "emblem_avatars/#{kingdom[:name].downcase}.png",
                     king_avatar: "king_avatars/#{king_avatars.pop}.png")
    end
  end
end
