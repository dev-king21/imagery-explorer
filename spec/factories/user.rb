FactoryBot.define do
  factory :user do
    name { Faker::Lorem.characters(number: 10) }
    email { Faker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }

    factory :confirmed_user, :parent => :user do
      before(:create) { |user| user.skip_confirmation! }
    end
  end
end