# README

Prerequisites
* one of the javascript runtimes that ExecJS supports (see https://github.com/rails/execjs) (tested using node.js v10.19.0)
* mariadb or mysql (tested using MariaDB 10.3.32)
* ruby-3.1.1

Installation
* create mysql database user and grant it priveleges by running the following in a mysql shell:
  * `create user 'provider_lookup_user'@'localhost' identified by '[choose your password]';`
  * `grant all on provider_lookup_development.* to 'provider_lookup_user'@'localhost';`
  * `grant all on provider_lookup_test.* to 'provider_lookup_user'@'localhost';`
* create [project_root]/config/development_database_password and put the password you chose inside
* run `gem install bundler`
* run the following commands from the project root directory:
  * `bundle install`
  * `bundle exec rake db:create`
  * `bundle exec rake db:migrate`

Run tests
* `bundle exec rake spec` from project root directory

Run server
* `rails s` from project root directory
