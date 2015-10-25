psql -U $1 -d noteshare_test --file psql.setup
psql -U $1 -d noteshare_development --file psql.setup
bundle install

echo
echo "Database and gems are installed."
echo 'Now run "lotus console," then'
echo 'say "NSDocument::Setup.seed_db" to complete installation'
echo
echo "Test the installation by pointing your browser to http://localhost:2300"
echo
