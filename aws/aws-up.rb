#!/usr/bin/env ruby

# require 'rubygems'
require 'aws-sdk'
# http://ruby.awsblog.com/post/Tx354Y6VTZ421PJ/-Downloading-Objects-from-Amazon-span-class-matches-S3-span-using-the-AWS-SDK-fo
# https://ruby.awsblog.com/post/Tx1K43Z7KXHM5D5/Uploading-Files-to-Amazon-S3

# vschool.s3.amazonaws.com

local_file = ARGV[0]
bucket = ARGV[1] || 'vschool/noteshare_images'

mime_type = ARGV[2] || "application/octet-stream"

s3 = Aws::S3::Resource.new(
  credentials: Aws::Credentials.new('AKIAISU5BH6OEAZPDSZQ', 'UgTe4TAJu1LGuZO7OOVzm3Q7Jfz0z775Cs9ctNql'),
  region: 'us-west-1',
  endpoint: 'https://s3.amazonaws.com'
)
base_name = File.basename(local_file)

puts "Uploading #{local_file} as '#{folder}/#{base_name}' to '#{bucket}'"
t1 = Time.now
obj = s3.bucket(bucket).object(base_name)
obj.upload_file("#{base_name}", acl: 'public-read')
t2 = Time.now
puts "Uploaded as #{obj.public_url}"
puts "Elapsed: #{t2-t1}"
