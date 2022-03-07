# RPL version 3 backend server

- Install [Ruby version 2.4.10 + DevKit](https://rubyinstaller.org/downloads/archives/)

- Install Bundler package manager: `gem install bundle`

- Run `bundle install --path=vendor/bundle` to download all dependencies

- Install [PostgreSQL](https://www.postgresql.org/download/) version 9.6

- Create _application.yml_ and _database.yml_ files from samples:

  - `cp config/application.yml.sample config/application.yml`
  - `mv config/database.yml.sample config/database.yml`

- Change the username and password in _database.yml_ to your local user

- Execute DB operations before starting the server:

  - rails db:environment:set RAILS_ENV=development
  - bundle exec rake db:setup --trace
  - bundle exec rake db:seed --trace
  - bundle exec rake db:migrate --trace
  - bundle exec rake prepare_league --trace
  - bundle exec rake start --trace

- Start the Puma server with `bundle exec puma .\config.ru -b tcp://localhost:3000`

<!--  -->
