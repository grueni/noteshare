workers Integer(ENV['PUMA_WORKERS'] || 2)
workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads Integer(ENV['MIN_THREADS']  || 1), Integer(ENV['MAX_THREADS'] || 8)

preload_app!

rackup      DefaultRackup

port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || ENV['LOTUS_ENV'] || 'development'

on_worker_boot do
   Lotus::Model.load!
end


