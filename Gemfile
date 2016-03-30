source 'https://rubygems.org'

ruby '2.2.3'
# ruby '2.3.0'

gem 'bundler'
gem 'rake'

gem 'puma'
gem "puma_worker_killer" # TEMPORARY MEASURE
# gem 'newrelic_rpm'
gem 'keen'

gem 'lotusrb',     '0.5.0'
gem 'lotus-model', '~> 0.5'
gem 'lotus-assets'
gem 'lotus-utils'


gem 'pg'

#   gem 'sequel'

gem 'slim'

gem 'bcrypt'
gem 'aws-sdk', '~> 2'

gem 'asciidoctor', '~> 1.5.2'
gem 'asciidoctor-latex', :github => 'asciidoctor/asciidoctor-latex', :branch => 'master'
gem 'thread_safe'
gem 'coderay'

# https://github.com/cyu/rack-cors
# gem 'rack-cors', :require => 'rack/cors'

# http://www.rubydoc.info/gems/jquery-lotus/0.0.1
gem 'jquery-lotus'

group :test do
  gem 'minitest'
  gem 'capybara'
  gem 'minitest-capybara'
end

group :development do
  gem 'shotgun'
end

group :production do
  # gem 'puma'
end
