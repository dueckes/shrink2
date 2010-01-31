Shrink - BDD artifact management tool
=====================================

A conventional Rails application managing BDD artifacts, currently limited to Cucumber features.

Highlights
----------

* Manage features, scenarios, steps
* Step fit table support
* Step auto-completion based on existing steps
* Organize features into folders
* Tag features
* Full-text search across features
* Manage feature projects

Development Installation instructions
-------------------------------------

### DATABASE

1. Install postgreSQL
* For Mac see http://developer.apple.com/internet/opensource/postgres.html

#  Configure UTF8 encoding
* Change template1 template database via (see http://www.postgresql.org/docs/8.1/interactive/manage-ag-templatedbs.html):

  $ psql -U postgres template1
  $ UPDATE pg_database SET datallowconn = TRUE where datname = 'template0';
  $ \c template0
  $ UPDATE pg_database SET datistemplate = FALSE where datname = 'template1';
  $ drop database template1;
  $ create database template1 with template = template0 encoding = 'UNICODE';
  $ UPDATE pg_database SET datistemplate = TRUE where datname = 'template1';
  $ \c template1
  $ UPDATE pg_database SET datallowconn = FALSE where datname = 'template0';

2. Create users

  $ createuser --createdb --pwprompt shrink_dev
  $ createuser --createdb --pwprompt shrink_test

See config/database.yml for exact details

3. Create development database

  $ createdb --owner=shrink_dev shrink_dev

4. Populate development database and create test database

  $ rake db:reset_and_prepare

### GEMS

* Install rack

  $ sudo gem install rack --no-ri --no-rdoc --version=1.0.1

* Install postgreSQL adapter
For Mac ensure `PGHOME/bin` is in root path then

    $ sudo su -
    $ export ARCHFLAGS="-arch x86_64"
    $ sudo gem install pg --no-ri --no-rdoc

* Install build specific gems

  $ sudo gem install rspec --no-ri --no-rdoc --version=1.2.9
  $ sudo gem install rspec-rails --no-ri --no-rdoc --version=1.2.9
  $ sudo gem install reek --no-ri --no-rdoc
  $ sudo gem install roodi --no-ri --no-rdoc
  $ sudo gem install rcov --no-ri --no-rdoc

### BUILD TARGETS

Full build: Performs migrations, resets test database and executes behaviors

  $ rake full

Behavior build:

  $ rake spec

Source code metrics analysis:

  $ rake metrics
  