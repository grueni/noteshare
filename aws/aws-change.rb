require 'aws-sdk'


include Aws::S3

# http://docs.aws.amazon.com/sdkforruby/api/Aws/S3.html
# http://docs.aws.amazon.com/AmazonS3/latest/API/RESTBucketGET.html
# v1: http://docs.aws.amazon.com/AWSRubySDK/latest/AWS/S3/Bucket.html
#     http://docs.aws.amazon.com/AWSRubySDK/latest/AWS/S3.html
# v2: http://docs.aws.amazon.com/sdkforruby/api/index.html
#     http://docs.aws.amazon.com/sdkforruby/api/Aws/S3.html

# Copying:
# http://docs.aws.amazon.com/AmazonS3/latest/dev/CopyingObjectsExamples.html


bucket_name = 'vschool/images'
marker = ""

s3 = Aws::S3::Resource.new(
    credentials: Aws::Credentials.new('xyz', 'abc')
    region: 'us-west-1',
    endpoint: 'https://s3.amazonaws.com'
)

=begin
s3.buckets.each do |bucket|
  puts bucket.name
end
=end


#Fixme: use AWS=SDK instead of rolling your own.
bucket = s3.buckets.to_a[2]   # .each.select{ |obj| obj.name == 'vschool'}

puts "Bucket = #{bucket.name}"



bucket.objects({prefix: 'noteshare_images'}).each do |obj|
  name = obj.key
  obj.acl(foo: 'bar')
  obj.copy_to("vschool/noteshare_images/#{new_name}")
end

=begin

loop do
  objects = Bucket.objects(bucket_name, :marker=>marker, :max_keys=>1000)
  break if objects.size == 0
  marker = objects.last.key

  objects.each do |obj|
    puts "#{obj.key}"
  end
end
=end

