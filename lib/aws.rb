module Noteshare


  module Util
    require 'net/http'
    require 'uri'

    def self.read_local_file(file_name, tmpfile)

      puts "Reading #{file_name}"
      str = IO.read(tmpfile)
      return str

    end

    def self.read_url(url)

      Net::HTTP.get(URI.parse(url))

    end

  end


  module AWS
    require 'aws-sdk'
    def self.upload(file_name, tmpfile, folder='tmp')

      bucket = "vschool/#{folder}"
      # mime_type = "application/octet-stream"

      s3 = Aws::S3::Resource.new(
          credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']),
          region: 'us-west-1',
          endpoint: 'https://s3.amazonaws.com'
      )

      base_name = File.basename(file_name)

      puts "Uploading #{file_name} as '#{base_name}' to '#{bucket}'"
      t1 = Time.now
      obj = s3.bucket(bucket).object(base_name)
      obj.upload_file(tmpfile, acl: 'public-read')
      t2 = Time.now
      message =  "Uploaded #{file_name} as #{obj.public_url} in #{t2-t1} seconds"
      puts message
      return obj.public_url

    end
  end
end