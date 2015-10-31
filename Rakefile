require 'rake'
require 'rake/testtask'

# https://mallibone.wordpress.com/tag/raketesttask/

Rake::TestTask.new do |t|
  t.pattern = 'spec/**/*_spec.rb'
  t.libs    << 'spec'
end

task default: :test
task spec: :test

# lib/tasks/db.rake
namespace :db do

  user = 'carlson'
  db = 'noteshare_development'
  here = '.'
  app = 'noteshare'

  desc "Drops the database tables for noteshare"
  task :reset do
    cmd = "psql -U #{user} -d noteshare_development --file ./psql.setup"
    puts cmd
    exec cmd
  end


  desc "Dumps the database to db/APP_NAME.dump"
  task :dump  do
    cmd = "pg_dump --host 'localhost' --username #{user} --verbose --clean --no-owner --no-acl --format=c #{db} > #{here}/db/#{app}.dump"
    puts cmd
    exec cmd
  end

  desc "Restores the database dump at db/APP_NAME.dump."
  task :restore do
    cmd = "pg_restore --verbose --host 'localhost' --username #{user} --clean --no-owner --no-acl --dbname #{db} #{here}/db/#{app}.dump"
    # Rake::Task["db:reset"].invoke
    puts cmd
    exec cmd
  end

end

namespace :update do

  desc "Update documentation"
  task :docs do
    `asciidoctor NOTES.adoc`
    `asciidoctor README.adoc`
    `asciidoctor design.adoc`
    `mv NOTES.html apps/web/public/html/`
    `mv README.html apps/web/public/html/`
    `mv design.html apps/web/public/html/`
  end

end