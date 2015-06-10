CarrierWave.configure do |config|
  if Rails.env.production? || Rails.env.staging?
    config.storage = :aws
    config.aws_bucket = ENV['S3_BUCKET_NAME']
    config.asset_host = 'http://vswamy-myflix-staging.s3-website-us-east-1.amazonaws.com'
    config.aws_credentials = {
      access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      region: ENV['AWS_REGION'] 
    }

  else
    config.storage = :file
    config.enable_processing = Rails.env.development?
  end
end