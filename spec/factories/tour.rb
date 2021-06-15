FactoryBot.define do
  factory :tour do
    name { Faker::Lorem.characters(number: 10) }
    description { Faker::Lorem.sentence }
    tag_names { "#{Faker::Lorem.characters(number: 4)}, #{Faker::Lorem.characters(number: 5)}" }
    tour_type { Constants::TOUR_TYPES[Constants::TOUR_TYPES.keys.sample] }
    transport_type { Constants::TRANSPORT_TYPES[Constants::TRANSPORT_TYPES.keys.sample] }
    tourer_tour_id { Faker::Lorem.characters(number:10) }
    tourer_version { Faker::Lorem.characters(number:5) }
    user

    trait :with_photos do
      after(:create) do |tour|
        create_list(:photo, 2, tour: tour)
      end
    end
  end
end