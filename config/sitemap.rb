# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = 'https://explorer.trekview.org'
# pick a place safe to write the files
SitemapGenerator::Sitemap.public_path = 'tmp/'
# store on S3 using Fog (pass in configuration values as shown above if needed)
SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new(
    fog_provider: 'AWS',
    aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
    fog_directory: ENV['FOG_DIRECTORY'],
    fog_region: ENV['FOG_REGION'])

# inform the map cross-linking where to find the other maps
SitemapGenerator::Sitemap.sitemaps_host = "http://#{ENV['FOG_DIRECTORY']}.s3.#{ENV['FOG_REGION']}.amazonaws.com/"
# pick a namespace within your bucket to organize your maps
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'

SitemapGenerator::Sitemap.create do
  add root_path, changefreq: 'daily'

  Tour.includes(:user).find_each do |tour|
    add user_tour_path(tour.user, tour), changefreq: 'daily', lastmod: tour.updated_at
  end

  User.find_each do |user|
    add user_path(user), changefreq: 'daily'

    user.tourbooks.each do |book|
      add user_tourbook_path(user, book)
    end
  end

  Photo.find_each do |photo|
    add photo_path(photo), changefreq: 'daily'
  end
end
