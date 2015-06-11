CarrierWave.configure do |config|
  if Rails.env.production? || Rails.env.staging?
    config.storage = :aws
    config.aws_bucket = ENV['S3_BUCKET_NAME']
    config.aws_credentials = {
      access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      # region: ENV['AWS_REGION'],
      # config: AWS.config({s3_endpoint: 's3-us-east-1.amazonaws.com'})
    }

  else
    config.storage = :file
    config.enable_processing = Rails.env.development?
  end
end