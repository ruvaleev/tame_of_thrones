# frozen_string_literal: true

FactoryBot.define do
  factory :game_set do
    uid { SecureRandom.hex }
  end
end
