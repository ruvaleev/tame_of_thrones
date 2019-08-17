FactoryBot.define do
  factory :message, class: 'Message' do
    body { FFaker::Lorem.sentence }
    association :sender, factory: :kingdom
    association :receiver, factory: :kingdom
  end
end
