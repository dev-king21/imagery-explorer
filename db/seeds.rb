require 'factory_bot_rails'

unless Rails.env.production?
  unless User.first
    test_user = User.new(name: 'Johnny', email: 'test_user@example.com', password: 'password', password_confirmation: 'password')
    test_user.skip_confirmation!
    test_user.save!
    FactoryBot.create_list(:tour, 6, :with_photos, user: test_user)

    4.times do
      user = FactoryBot.create(:confirmed_user)
      FactoryBot.create_list(:tour, 6, :with_photos, user: user)
    end
  end

  unless Tourbook.first
    FactoryBot.create_list(:tourbook, 3, :with_tours, user: User.first)
  end
end

AdminUser.create!(email: ENV['ADMIN_EMAIL'], password: ENV['ADMIN_PASSWORD'], password_confirmation: ENV['ADMIN_PASSWORD']) if Rails.env.development?