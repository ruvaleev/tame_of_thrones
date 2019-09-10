# Creating kingdoms
class ReinitializeKingdoms
  def self.run
    Kingdom.destroy_all

    king_avatars = [1, 2, 3, 4, 5, 6]
    Kingdom::GREAT_HOUSES.each do |kingdom|
      k = Kingdom.new(name: kingdom[:name],
                      emblem: kingdom[:emblem],
                      king: kingdom[:king] || FFaker::Name.first_name)
      File.open(Rails.root.join('public', 'emblem_avatars', "#{kingdom[:name].downcase}.jpg")) do |f|
        k.emblem_avatar = f
      end
      File.open(Rails.root.join('public', 'king_avatars', "#{king_avatars.delete(king_avatars.sample)}.jpg")) do |f|
        k.king_avatar = f
      end
      k.save
    end
  end
end
