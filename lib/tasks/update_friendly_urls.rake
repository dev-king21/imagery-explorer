namespace :friendly_id do
  desc 'update models friendly-id slugs(set nil to regenerate)'
  task update_urls: :environment do

    Tour.find_each do |tour|
      tour.slug = nil
      tour.save
    end
    Tourbook.find_each do |tourbook|
      tourbook.slug = nil
      tourbook.save
    end

  end
end
