# Creating kingdoms
[
  { name: 'Space', emblem: 'Gorilla' },
  { name: 'Land', emblem: 'Panda' },
  { name: 'Water', emblem: 'Octopus' },
  { name: 'Ice', emblem: 'Mammoth' },
  { name: 'Air', emblem: 'Owl' },
  { name: 'Fire', emblem: 'Dragon' }
].each do |kingdom|
  Kingdom.create(name: kingdom[:name], emblem: kingdom[:emblem])
end

Kingdom.find_by(name: 'Space').update(ruler: true)
