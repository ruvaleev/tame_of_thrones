# Creating kingdoms
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
  File.open(Rails.root.join('public', 'avatars', "#{kingdom[:name].downcase}.jpg")) { |f| k.avatar = f }
  k.save
end
