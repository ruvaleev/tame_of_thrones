# Creating kingdoms
[
  { name: 'Space', emblem: 'Gorilla', king: 'Shan' },
  { name: 'Land', emblem: 'Panda' },
  { name: 'Water', emblem: 'Octopus' },
  { name: 'Ice', emblem: 'Mammoth' },
  { name: 'Air', emblem: 'Owl' },
  { name: 'Fire', emblem: 'Dragon' }
].each do |kingdom|
  Kingdom.create(name: kingdom[:name], emblem: kingdom[:emblem], king: kingdom[:king] || FFaker::Name.first_name)
end
