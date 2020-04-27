# frozen_string_literal: true

FactoryBot.define do
  factory :kingdom, class: 'Kingdom' do
    sequence :name_en do |n|
      "Kingdom_name_#{n}"
    end
    sequence :name_ru do |n|
      "Название_королевства_#{n}"
    end
    sequence :emblem_en do |n|
      "Kingdom_emblem_#{n}"
    end
    sequence :emblem_ru do |n|
      "Герб_королевства_#{n}"
    end
    title { %w[king queen].sample }
    leader_en { generate_name_en(title) }
    leader_ru { generate_name_ru(title) }
    emblem_avatar { 'support/test_image.png' }
    leader_avatar { 'support/test_image.png' }
  end
end

def generate_name_en(title)
  title == 'king' ? FFaker::Name.first_name_male : FFaker::Name.first_name_female
end

def generate_name_ru(title)
  title == 'king' ? FFaker::NameRU.first_name_male : FFaker::NameRU.first_name_female
end
