FactoryBot.define do
  factory :kingdom, class: 'Kingdom' do
    sequence :name do |n|
      "Kingdom_name_#{n}"
    end
    sequence :emblem do |n|
      "Kingdom_emblem_#{n}"
    end
    king { FFaker::Name.first_name }
    sequence :emblem_avatar do |n|
      ActionDispatch::Http::UploadedFile
        .new(tempfile: File.new(Rails.root.join('spec', 'support', 'images', 'test_image.png')),
             filename: "emblem_avatar_#{n}")
    end
    sequence :king_avatar do |n|
      ActionDispatch::Http::UploadedFile
        .new(tempfile: File.new(Rails.root.join('spec', 'support', 'images', 'test_image.png')),
             filename: "king_avatar_#{n}")
    end
  end
end
