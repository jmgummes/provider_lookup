# README

Installation
* install mariadb or mysql (project was tested using MariaDB 10.3.32)
* create database user and grant it priveleges by running the following in a mysql shell:
  * `create user 'provider_lookup_user'@'localhost' identified by '[choose your password]';`
  * `grant all on provider_lookup_development.* to 'provider_lookup_user'@'locahost';`
  * `grant all on provider_lookup_test.* to 'provider_lookup_user'@'localhost';`
* create [project_root]/config/development_database_password and put the password you chose inside
* install ruby-3.1.1
* run `gem install bundler`
* run the following commands from the project root directory:
  * `bundle install`
  * `bundle exec rake db:create`
  * `bundle exec rake db:migrate`

Run tests
* `bundle exec rake spec` from project root directory

Run server
* `rails s` from project root directory
