FactoryBot.define do
  factory :kingdom, class: 'Kingdom' do
    sequence :name do |n|
      "Kingdom_name_#{n}"
    end
    sequence :emblem do |n|
      "Kingdom_emblem_#{n}"
    end
    king { FFaker::Name.first_name }
  end
end
