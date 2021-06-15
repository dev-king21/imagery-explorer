require 'aws-sdk'

if ENV['AWS_ACCESS_KEY_ID'] && ENV['AWS_SECRET_ACCESS_KEY']
  Aws.config.update({
    credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'])
  })

  S3_BUCKET = Aws::S3::Resource.new(region: ENV['AWS_S3_BUCKET_REGION']).bucket(ENV['AWS_S3_BUCKET'])
end