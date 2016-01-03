echo "\n\n ==> dump noteshare database"
rake db:dump
echo "\n\n ==> upload database to s3"
ruby up.rb db/noteshare.dump
echo "\n\n ==> stop dynos at heroku"
heroku ps:stop DYNOS
echo "\n\n ==> restore database at heroku"
rake db:herokurestore
echo "\n\n ==> restrart heroku"
heroku restart
echo "\n\n ==> starting heroku logs"
heroku logs --tail
