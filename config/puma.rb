workers Integer(ENV['PUMA_WORKERS'] || 2)
# workers Integer(ENV['WEB_CONCURRENCY'] || 2
threads Integer(ENV['MIN_THREADS']  || 1), Integer(ENV['MAX_THREADS'] || 8)

preload_app!

rackup      DefaultRackup

port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || ENV['LOTUS_ENV'] || 'development'

on_worker_boot do
   Lotus::Model.load!
end


=begin

workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['MAX_THREADS'] || 5)
threads threads_count, threads_count

preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || ENV['LOTUS_ENV'] || 'development'

on_worker_boot do
  # Worker specific setup for Rails 4.1+
  # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  #  ActiveRecord::Base.establish_connection
end


# workers Integer(ENV['PUMA_WORKERS'] || 3)


=end