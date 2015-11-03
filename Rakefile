require 'rake'
require 'rake/testtask'

# https://mallibone.wordpress.com/tag/raketesttask/

Rake::TestTask.new do |t|
  t.pattern = 'spec/**/*_spec.rb'
  t.libs    << 'spec'
end

task default: :test
task spec: :test

namespace :t do

  desc "Run tests on NSDocumnt entity"
  task :doc do
    cmd = 'ruby -I"Lib:spec" spec/noteshare/entities/document2_spec.rb'
    exec cmd
  end

  desc "Run tests on Lesson entity"
  task :lesson do
    cmd = 'ruby -I"Lib:spec" spec/noteshare/entities/lesson_spec.rb'
    exec cmd
  end

  desc "Run tests on Course entity"
  task :course do
    cmd = 'ruby -I"Lib:spec" spec/noteshare/entities/course_spec.rb'
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

  desc "Drops the database tables for noteshare"
  task :reset do
    cmd = "psql -U #{user} -d noteshare_development --file ./psql.setup"
    puts cmd
    #  exec cmd
    system cmd
  end


  desc "Dumps the database to db/APP_NAME.dump"
  task :dump  do
    cmd = "pg_dump --host 'localhost' --username #{user} --verbose --clean --no-owner --no-acl --format=c #{db} > #{here}/db/#{app}.dump"
    puts cmd
    exec cmd
  end

  desc "Restores the database dump at db/APP_NAME.dump."
  task :restore => :reset do
    cmd = "pg_restore --verbose --host 'localhost' --username #{user} --clean --no-owner --no-acl --dbname #{db} #{here}/db/#{app}.dump"
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


