FactoryBot.define do
  factory :photo do
    taken_at { 1.day.ago }
    latitude { rand(-90.000000000...90.000000000) }
    longitude { rand(-180.000000000...180.000000000) }
    elevation_meters { rand(100...999) }
    camera_make { Faker::Lorem.characters(number:5) }
    camera_model { Faker::Lorem.characters(number:5) }
    google {{
        plus_code_global_code: Faker::Lorem.characters(number: 10),
        plus_code_compound_code: Faker::Lorem.characters(number:30)
    }}
    address {{
        cafe: '',
        road: '',
        suburb: '',
        county: '',
        region: '',
        state: '',
        postcode: '',
        country: Faker::Address.country,
        country_code: Faker::Address.country_code
    }}
    streetview {{
        photo_id: Faker::Lorem.characters(number:10),
        capture_time: rand(1...10).day.ago,
        share_link: Faker::Internet.url,
        download_url: Faker::Internet.url,
        thumbnail_url: Faker::Internet.url,
        "lat": rand(-90.000000000...90.000000000).to_i,
        "lon": rand(-180.000000000...180.000000000).to_i,
        altitude: rand(100...999),
        heading: rand(1...359),
        pitch: rand(-90...90),
        roll: rand(1...360),
        level: rand(1...10),
        connections: [
          rand(1...10),
          rand(1...10)
        ]
    }}
    tourer {{
        photo_id: Faker::Lorem.characters(number:10),
        connections: (1..10).map do |n|
        {
            photo_id: Faker::Lorem.characters(number:10),
            distance_meters: rand(1...10),
            heading: rand(1...359),
            elevation_meters: rand(1...10)
        }
      end

    }}
    opentrailview {{ photo_id: Faker::Lorem.characters(number:20) }}
    image { Rack::Test::UploadedFile.new(Rails.root.join(Rails.env.test? ? 'spec/support/images/sample.jpeg' : "spec/support/images/#{rand(5)}.jpg"), 'image/jpeg') }
    tourer_photo_id { Faker::Lorem.characters(number:10) }
    tourer_connection_photos { Faker::Lorem.characters(number:10) }
    country { Faker::Address.country_code }
    filename { Faker::Lorem.characters(number:10) }
    tour
  end
end
