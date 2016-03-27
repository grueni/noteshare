require 'rake'
require 'rake/testtask'

# https://mallibone.wordpress.com/tag/raketesttask/

Rake::TestTask.new do |t|
  # t.pattern = 'spec/**/controllers/**/*_spec.rb'
  t.pattern = 'spec/**/*_spec.rb'
  t.libs    << 'spec'
end

task default: :test
task spec: :test


namespace :t do

  desc "Run test on ACL"
  task :acl do
    cmd = 'ruby -I"Lib:spec" spec/acl_spec.rb'
    exec cmd
  end

  desc "Run tests on Session Manager"
  task :session do
    cmd = 'ruby -I"Lib:spec" spec/session_manager/features/*'
    exec cmd
  end

end

# lib/tasks/db.rake
namespace :db do

  user = 'carlson'
  db = 'noteshare_development'
  db_test = 'noteshare_test'
  here = '.'
  app = 'noteshare'

  desc "Push local database to heroku"
  task :push_heroku do
    cmd = "heroku ps:stop DYNOS; "
    cmd << "heroku pg:reset DATABASE_URL --app nslab; "
    cmd << "heroku pg:push noteshare_development DATABASE_URL --app nslab; "
    cmd << "heroku restart; "
    cmd << "heroku logs --tail"
    puts cmd
    exec cmd
  end

  desc "Pull local database from heroku"
  task :pull_heroku do
    cmd = "dropdb noteshare_development; "
    cmd << "heroku pg:pull DATABASE_URL noteshare_development --app nslab; "
    puts cmd
    exec cmd
  end

  desc "Drops the database tables for noteshare"
  task :reset do
    cmd = "psql -U #{user} -d noteshare_development --file ./psql.setup"
    puts cmd
    exec cmd
    # system cmd
  end


  desc "Dumps the database to db/APP_NAME.dump"
  task :dump  do
    puts "===> Dump noteshare database"
    cmd = "pg_dump --host 'localhost' --username #{user} --verbose --clean --no-owner --no-acl --format=c #{db} > #{here}/db/#{app}.dump"
    puts cmd
    exec cmd
  end

  desc "Dumps the test database to db/APP_NAME_test.dump"
  task :dump_test  do
    puts "===> Dump noteshare database"
    cmd = "pg_dump --host 'localhost' --username #{user} --verbose --clean --no-owner --no-acl --format=c #{db_test} > #{here}/db/#{app}_test.dump"
    puts cmd
    exec cmd
  end

  desc "Dump noteshare database offline. Bravo!!"
  task :herokudump  do
    cmd = 'PGPASSWORD=Password -Fc --no-acl --no-owner -h localhost -U carlson noteshare_development > jcdb.dump'
    exec cmd
  end

  desc "Restore heroku database from dump at S3"
  task :herokurestore do
    cmd = "heroku pg:backups restore 'http://vschool.s3.amazonaws.com/noteshare.dump' DATABASE_URL"
    exec cmd
  end

  desc "Restores the local database from the dump at db/APP_NAME.dump."
  # task :restore => :reset do
  task :restore  do
    cmd = "pg_restore --verbose --host 'localhost' --username #{user} --clean --no-owner --no-acl --dbname #{db} #{here}/db/#{app}.dump"
    # Rake::Task["db:reset"].invoke
    puts cmd
    exec cmd
  end

  desc "Restores the test database dump at db/APP_NAME.dump."
  task :restore_test => :reset do
    cmd = "pg_restore --verbose --host 'localhost' --username #{user} --clean --no-owner --no-acl --dbname #{db_test} #{here}/db/#{app}_test.dump"
    # Rake::Task["db:reset"].invoke
    puts cmd
    exec cmd
  end

  desc "`Loads vschool.dump."
  task :load_vschool do
    cmd = "pg_restore --verbose --host 'localhost' --username #{user} --clean --no-owner --no-acl --dbname #{db} #{here}/db/vschool.dump"
    # Rake::Task["db:reset"].invoke
    puts cmd
    exec cmd
  end

  desc "`Loads vschool.dump."
  task :load_vschool_test do
    cmd = "pg_restore --verbose --host 'localhost' --username #{user} --clean --no-owner --no-acl --dbname #{db_test} #{here}/db/vschool.dump"
    # Rake::Task["db:reset"].invoke
    puts cmd
    exec cmd
  end

  desc "Updates heroku db."
  # task :update_heroku => :dump do
  task :update_heroku do
    # Rake::Task[:dump].invoke
    puts "===> Update Heroku"
    cmd = "ruby up.rb db/noteshare.dump"
    puts cmd
    exec cmd
  end

=begin
  task :primary => [:secondary]

  task :secondary do
    puts "Doing Secondary Task"
  end
But if you really, really need to call the tasks directly you can use invoke to call another task

  task :primary do
    Rake::Task[:secondary].invoke
  end

  task :secondary do
    puts "Doing Secondary Task"
  end
=end

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


# http://lukaszwrobel.pl/blog/rake-tutorial
# https://viget.com/extend/protip-passing-parameters-to-your-rake-tasks
# http://rake.rubyforge.org/doc/rakefile_rdoc.html
# alias rake='noglob rake'  --- see http://dev.scottw.com/zsh-rake-parameters
namespace :x do


  desc "test"
  task :test do
    puts "This is a test"
  end

  task :ring do
    puts "Bell is ringing."
  end

  task :enter => :ring do
    puts "Entering home!"
  end

  desc "Basic call and response"
  task :call1 do
    response = 'Task'
    puts "When I say Rake, you say '#{response}'!"
    sleep 1
    puts "Rake!"
    sleep 1
    puts "#{response}!"
  end

  desc "Basic call and response"
  task :call, :response do |t, args|
    response = args[:response]
    puts "When I say Rake, you say '#{response}'!"
    sleep 1
    puts "Rake!"
    sleep 1
    puts "#{response}!"
  end

end


