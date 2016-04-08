  module Noteshare


  module Util
    require 'net/http'
    require 'uri'
    require "open-uri"

    def self.read_local_file(file_name, tmpfile)

      puts "Reading #{file_name}"
      str = IO.read(tmpfile)
      return str

    end

    def self.read_url(url)

      Net::HTTP.get(URI.parse(url))

    end

    def self.save_url_to_file(url, file_name)

      File.open(file_name, 'wb') do |fo|
        fo.write open(url).read
      end

    end

  end


  ### INTERFACE ###
  # AWS.upload
  # AWS.put_string
  # AWS.get_string
  module AWS
    require 'aws-sdk'

    ### INTERFACE ###

    def self.upload(file_name, tmpfile, folder='tmp')

      bucket = "vschool"
      # mime_type = "application/octet-stream"

      s3 = Aws::S3::Resource.new(
          credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']),
          region: 'us-west-1',
          endpoint: 'https://s3.amazonaws.com'
      )

      base_name = File.basename(file_name)

      puts "Uploading #{file_name} as '#{folder}/#{base_name}' to '#{bucket}'"
      t1 = Time.now
      obj = s3.bucket(bucket).object("#{folder}/#{base_name}")
      obj.upload_file(tmpfile, acl: 'public-read')
      t2 = Time.now
      message =  "Uploaded #{file_name} as #{obj.public_url} in #{t2-t1} seconds"
      puts message
      return obj.public_url

    end


    # create file on S3 from string str\
    # http://docs.aws.amazon.com/AmazonS3/latest/dev/UploadObjSingleOpRuby.html
    def self.put_string(str, object_name, folder='tmp')

      bucket = "vschool"
      object_name = "#{folder}/#{object_name}"
      # mime_type = "application/octet-stream"

      s3 = Aws::S3::Resource.new(
          credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']),
          region: 'us-west-1',
          endpoint: 'https://s3.amazonaws.com'
      )

      puts "Uploading string [#{str[0..100]} as '#{object_name}' to '#{bucket}'".red

      obj = s3.bucket(bucket).object(object_name)

      obj.put(body: str)

    end

    # read file on S3 and return it as a string
    # https://ruby.awsblog.com/post/Tx354Y6VTZ421PJ/Downloading-Objects-from-Amazon-S3-using-the-AWS-SDK-for-Ruby
    def self.get_string(object_name, folder='tmp')

      bucket = "vschool"
      object_name = "#{folder}/#{object_name}"
      # mime_type = "application/octet-stream"

      s3 = Aws::S3::Client.new(
          credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']),
          region: 'us-west-1',
          endpoint: 'https://s3.amazonaws.com'
      )

      puts "Receiving contents of #{object_name}".red

      resp = s3.get_object(bucket: bucket, key: object_name)

      resp.body.read

    end




  end
end