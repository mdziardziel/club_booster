AWS_CLIENT = Aws::S3::Client.new(
  region: 'eu-west-1',
  access_key_id: ENV['AWS_ACCESS_KEY_ID'],
  secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
)