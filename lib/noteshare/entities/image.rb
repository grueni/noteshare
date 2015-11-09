# require 'aws-sdk'

# include Aws

class Image
  include Lotus::Entity
  attributes :id, :title, :file_name, :mime_type, :created_at, :modified_at, :owner_id, :public, :doc_ids, :tags, :meta, :url, :identifier, :source


=begin
  def self.upload(local_file)

  # http://ruby.awsblog.com/post/Tx354Y6VTZ421PJ/-Downloading-Objects-from-Amazon-span-class-matches-S3-span-using-the-AWS-SDK-fo
  # https://ruby.awsblog.com/post/Tx1K43Z7KXHM5D5/Uploading-Files-to-Amazon-S3

    # http://docs.aws.amazon.com/sdkforruby/api/index.html

    bucket = 'vschool/noteshare_images'

    # mime_type = "application/octet-stream"


    s3 = Aws::S3::Resource.new(
        credentials: Aws::Credentials.new('ENV[AWS_ACCESS_KEY_ID], ENV[AWS_SECRET_ACCESS_KEY]'),
        region: 'us-west-1',
        endpoint: 'https://s3.amazonaws.com'
    )

    base_name = File.basename(local_file)

    t1 = Time.now
    obj = s3.bucket(bucket).object(base_name)
    obj.upload_file("outbox/#{base_name}", acl: 'public-read')
    t2 = Time.now
    message =  "Uploaded as #{obj.public_url}"
    message << "Elapsed: #{t2-t1}\n"
  end

=end

  def object_name(size='original')
    old_name = self.file_name
    name_parts = old_name.split('/')
    file_name = name_parts[-1]
    base_name, extension = file_name.split('.')
    new_name = "#{base_name}-#{size}.#{extension}"
    "vschool/noteshare_images/#{new_name}"
  end

  def url(size='original')
    "http://s3.amazonaws.com/#{self.object_name}"
  end


end
