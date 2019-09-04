# Creating kingdoms
king_avatars = [1,2,3,4,5,6]
[
  { name: 'Space', emblem: 'Gorilla', king: 'Shan' },
  { name: 'Land', emblem: 'Panda' },
  { name: 'Water', emblem: 'Octopus' },
  { name: 'Ice', emblem: 'Mammoth' },
  { name: 'Air', emblem: 'Owl' },
  { name: 'Fire', emblem: 'Dragon' }
].each do |kingdom|
  k = Kingdom.new(name: kingdom[:name],
                  emblem: kingdom[:emblem],
                  king: kingdom[:king] || FFaker::Name.first_name)
  File.open(Rails.root.join('public', 'emblem_avatars', "#{kingdom[:name].downcase}.jpg")) { |f| k.emblem_avatar = f }
  File.open(Rails.root.join('public', 'king_avatars', "#{king_avatars.delete(king_avatars.sample)}.jpg")) do |f|
    k.king_avatar = f
  end
  k.save
end
